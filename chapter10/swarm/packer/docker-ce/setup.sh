#!/bin/bash

echo "Install Docker engine"
yum update -y
yum install docker -y
usermod -aG docker ec2-user
systemctl enable docker