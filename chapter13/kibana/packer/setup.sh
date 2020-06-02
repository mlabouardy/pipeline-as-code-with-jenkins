#!/bin/bash

echo "Install Java & Unzip"
add-apt-repository ppa:openjdk-r/ppa
apt update
apt install -y openjdk-11-jdk unzip

echo "Install Kibana"
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | apt-key add -
apt-get install -y apt-transport-https
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | tee -a /etc/apt/sources.list.d/elastic-7.x.list
apt update
apt install -y kibana
mv /tmp/kibana.yml /etc/kibana/kibana.yml

echo "Start Kibana"
systemctl daemon-reload
systemctl enable kibana
systemctl start kibana