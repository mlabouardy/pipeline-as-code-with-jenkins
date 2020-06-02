#!/bin/bash

echo "Install Grafana"
wget https://dl.grafana.com/oss/release/grafana-7.0.1-1.x86_64.rpm
yum install -y grafana-7.0.1-1.x86_64.rpm
mv /tmp/grafana.ini /etc/grafana/grafana.ini
chkconfig grafana-server on
service grafana-server start