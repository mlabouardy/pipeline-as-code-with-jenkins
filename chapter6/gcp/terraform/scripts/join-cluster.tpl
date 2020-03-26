#!/bin/bash

JENKINS_URL="${jenkins_url}"
JENKINS_USERNAME="${jenkins_username}"
JENKINS_PASSWORD="${jenkins_password}"
TOKEN=$(curl -u $JENKINS_USERNAME:$JENKINS_PASSWORD ''$JENKINS_URL'/crumbIssuer/api/xml?xpath=concat(//crumbRequestField,":",//crumb)')
INSTANCE_NAME=$(curl -s metadata.google.internal/0.1/meta-data/hostname)
INSTANCE_IP=$(curl -s metadata.google.internal/0.1/meta-data/network | jq -r '.networkInterface[0].ip')
JENKINS_CREDENTIALS_ID="${jenkins_credentials_id}"

curl -v -u $JENKINS_USERNAME:$JENKINS_PASSWORD -H "Jenkins-Crumb:$TOKEN" -d 'script=
import hudson.model.Node.Mode
import hudson.slaves.*
import jenkins.model.Jenkins
import hudson.plugins.sshslaves.SSHLauncher

DumbSlave dumb = new DumbSlave("'$INSTANCE_NAME'",
"'$INSTANCE_NAME'",
"/home/ec2-user",
"3",
Mode.NORMAL,
"workers",
new SSHLauncher("'$INSTANCE_IP'", 22, "'$JENKINS_CREDENTIALS_ID'"),
RetentionStrategy.INSTANCE)
Jenkins.instance.addNode(dumb)
' $JENKINS_URL/script