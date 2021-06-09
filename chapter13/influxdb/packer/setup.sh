#!/bin/bash

echo "Install InfluxDB"
wget https://dl.influxdata.com/influxdb/releases/influxdb-1.8.0.x86_64.rpm
yum -y localinstall influxdb-1.8.0.x86_64.rpm
systemctl restart influxdb
systemctl enable influxdb