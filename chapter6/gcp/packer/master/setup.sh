#!/bin/bash

echo "Install utils tools"
yum install -y wget unzip

echo "Install Jenkins stable release"
yum remove -y java
yum install -y java-1.8.0-openjdk
wget -O /etc/yum.repos.d/jenkins.repo http://pkg.jenkins-ci.org/redhat-stable/jenkins.repo
rpm --import https://jenkins-ci.org/redhat/jenkins-ci.org.key
yum install -y jenkins
chkconfig jenkins on

echo "Install git"
yum install -y git

echo "Setup SSH key"
mkdir /var/lib/jenkins/.ssh
touch /var/lib/jenkins/.ssh/known_hosts
chown -R jenkins:jenkins /var/lib/jenkins/.ssh
chmod 700 /var/lib/jenkins/.ssh
mv /tmp/id_rsa /var/lib/jenkins/.ssh/id_rsa
chmod 600 /var/lib/jenkins/.ssh/id_rsa

echo "Configure Jenkins"
mkdir -p /var/lib/jenkins/init.groovy.d
mv /tmp/scripts/basic-security.groovy /var/lib/jenkins/init.groovy.d/basic-security.groovy
mv /tmp/scripts/disable-cli.groovy /var/lib/jenkins/init.groovy.d/disable-cli.groovy
mv /tmp/scripts/csrf-protection.groovy /var/lib/jenkins/init.groovy.d/csrf-protection.groovy
mv /tmp/scripts/disable-jnlp.groovy /var/lib/jenkins/init.groovy.d/disable-jnlp.groovy
mv /tmp/scripts/node-agent.groovy /var/lib/jenkins/init.groovy.d/node-agent.groovy
mv /tmp/scripts/skip-jenkins-setup.groovy /var/lib/jenkins/init.groovy.d/skip-jenkins-setup.groovy
mv /tmp/config/jenkins /etc/sysconfig/jenkins
chmod +x /tmp/config/install-plugins.sh
bash /tmp/config/install-plugins.sh
service jenkins start