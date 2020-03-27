#!/bin/bash

JENKINS_URL="${jenkins_url}"
JENKINS_USERNAME="${jenkins_username}"
JENKINS_PASSWORD="${jenkins_password}"
TOKEN=$(curl -u $JENKINS_USERNAME:$JENKINS_PASSWORD ''$JENKINS_URL'/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')
INSTANCE_NAME=$(curl -s http://169.254.169.254/metadata/v1/hostname)
INSTANCE_IP=$(curl -s http://169.254.169.254/metadata/v1/interfaces/public/0/ipv4/address)
JENKINS_CREDENTIALS_ID="${jenkins_credentials_id}"

curl -v -u $JENKINS_USERNAME:$JENKINS_PASSWORD -H "Jenkins-Crumb:$TOKEN" -d 'script=
import hudson.model.Node.Mode
import hudson.slaves.*
import jenkins.model.Jenkins
import hudson.plugins.sshslaves.SSHLauncher

DumbSlave dumb = new DumbSlave("'$INSTANCE_NAME'",
"'$INSTANCE_NAME'",
"/home/root",
"3",
Mode.NORMAL,
"workers",
new SSHLauncher("'$INSTANCE_IP'", 22, "'$JENKINS_CREDENTIALS_ID'"),
RetentionStrategy.INSTANCE)
Jenkins.instance.addNode(dumb)
' $JENKINS_URL/script