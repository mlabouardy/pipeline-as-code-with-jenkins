#!/bin/bash

curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.13.2-x86_64.rpm
sudo rpm -vi filebeat-7.13.2-x86_64.rpm
systemctl enable filebeat