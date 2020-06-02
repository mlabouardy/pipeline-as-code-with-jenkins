#!/bin/bash

echo "Install Java & unzip"
add-apt-repository ppa:openjdk-r/ppa
apt update
apt install -y openjdk-11-jdk unzip

echo "Install ElasticSearch 6"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
apt-get install -y apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
apt update
apt install -y elasticsearch
chown -R elasticsearch:elasticsearch /usr/share/elasticsearch
mv /tmp/elasticsearch.yml /etc/elasticsearch/elasticsearch.yml

echo "Start ElasticSearch"
systemctl daemon-reload
systemctl enable elasticsearch.service
systemctl start elasticsearch.service