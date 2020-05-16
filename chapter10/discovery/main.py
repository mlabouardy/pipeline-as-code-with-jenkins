import os
import sys
import time
import json
import docker
import boto3
import itertools
import botocore.exceptions
from random import random

docker_client = docker.from_env()

#TODO - use DynamoDB
class S3Discovery:
    def __init__(self, bucket, swarm_name):
        self.client = boto3.client('s3')
        self.bucket = bucket
        self.swarm_name = swarm_name

    def _list_objects(self, path):
        res = self.client.list_objects(Bucket=self.bucket, Prefix=self.swarm_name + "/" + path)
        if 'Contents' in res:
            return res['Contents']
        return []

    def _get_object(self, key):
        obj = self.client.get_object(Bucket=self.bucket, Key=self.swarm_name + "/" + key)
        return obj["Body"].read()

    def _put_object(self, key, body):
        self.client.put_object(Bucket=self.bucket, Key=self.swarm_name + "/" + key, Body=body, ServerSideEncryption='AES256')

    def _object_exists(self, key):
        try:
            self.client.head_object(Bucket=self.bucket, Key=self.swarm_name + "/" + key)
            return True
        except botocore.exceptions.ClientError as e:
            return False

    def list_managers(self):
        while True:
            items = self._list_objects("managers")
            if len(items):
                log("Found %d managers, waiting 5 seconds before continuing..." % len(items))
                time.sleep(5) # Give S3 time to syndicate all objects before next request
                return [json.loads(self._get_object(i['Key'][len(self.swarm_name + "/"):])) for i in items]
            log("No managers found, waiting 5 seconds before retrying...")
            time.sleep(5)

    def add_manager(self, ip):
        data = {"ip": ip}
        self._put_object("managers/%s" % ip, json.dumps(data))
    
    def add_worker(self, ip):
        data = {"ip": ip}
        self._put_object("workers/%s" % ip, json.dumps(data))

    def get_tokens(self):
        return json.loads(self._get_object("tokens"))

    def get_token(self, role):
        tokens = self.get_tokens()
        return tokens[role]

    def set_tokens(self, data):
        self._put_object("tokens", json.dumps(data))

    def get_initial_lock(self, label = "lock"):

        if self._object_exists("manager-init-lock"):
            return False;

        log("Did not find existing swarm, attempting to initialize")

        lock_set = "%s: %f" % (label, random())

        self._put_object("manager-init-lock", lock_set)

        # Make sure we give other nodes time to check and write their IP
        # if our IP is still the one in the file after 5 seconds, then we are probably okay
        # to assume we are the manager
        time.sleep(5)

        lock_read = self._get_object("manager-init-lock")

        log("Comparing locks: %s => %s" % (lock_set, lock_read))

        return lock_read == lock_set

class SwarmHelper:
    def __init__(self, node_ip):
        self.node_ip = node_ip

    def is_in_swarm(self):
        return docker_client.info()["Swarm"]["LocalNodeState"] == "active"

    def init(self):
        docker_client.swarm.init(listen_addr=self.node_ip, advertise_addr=self.node_ip)

    def join_tokens(self):
        tokens = docker_client.swarm.attrs["JoinTokens"]
        return { "manager": tokens["Manager"], "worker": tokens["Worker"] }

    def join(self, token, managers):

        ips = [m["ip"] for m in managers]

        log("Attempting to join swarm as %s via managers %s" % (self.node_ip, ips))

        docker_client.swarm.join(
            remote_addrs=ips,
            join_token=token,
            listen_addr=self.node_ip,
            advertise_addr=self.node_ip
        )

        log("Joined swarm")

def log(l):
    sys.stdout.write(l + "\n")
    sys.stdout.flush()

def main():
    log("Starting swarm setup")

    bucket = os.environ["SWARM_DISCOVERY_BUCKET"]
    swarm_name = os.environ["SWARM_NAME"]
    role = os.environ["ROLE"]
    node_ip = os.environ["NODE_IP"]

    # TODO validate these

    log("Using discovery bucket %s to configure node as a %s on address %s" % (bucket, role, node_ip))

    discovery = S3Discovery(bucket, swarm_name)
    swarm = SwarmHelper(node_ip)

    if role == "manager" and discovery.get_initial_lock(node_ip):
        log("Initializing new swarm")
        swarm.init()
        discovery.set_tokens(swarm.join_tokens())
    else:
        log("Joining existing swarm")
        managers = discovery.list_managers()
        swarm.join(discovery.get_token(role), managers)

    if role == "manager":
        log("Sending manager IP to discovery bucket")
        discovery.add_manager(node_ip)
    
    if role == "worker":
        log("Sending worker IP to discovery bucket")
        discovery.add_worker(node_ip)

    log("Completed swarm setup")

if __name__ == '__main__':
    main()