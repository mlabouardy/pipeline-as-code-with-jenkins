#!/bin/bash

echo "Install Java JDK 8"
yum remove -y java
yum install -y java-1.8.0-openjdk

echo "Install Docker engine"
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum update -y
yum install -y docker-ce-18.09.1
systemctl start docker

echo "Install git"
yum install -y git jq