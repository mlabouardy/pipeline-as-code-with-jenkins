#!/bin/bash

echo "Install Java & unzip"
add-apt-repository ppa:openjdk-r/ppa
apt update
apt install -y openjdk-11-jdk unzip

echo "Install Logstash"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
apt-get install -y apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
apt update
apt install -y logstash
mv /tmp/jenkins.conf /etc/logstash/conf.d/jenkins.conf

echo "Start ElasticSearch"
systemctl daemon-reload
systemctl enable logstash.service
systemctl start logstash.service