#!/bin/bash
wget https://dl.influxdata.com/telegraf/releases/telegraf-1.19.0-1.x86_64.rpm
yum localinstall -y telegraf-1.19.0-1.x86_64.rpm
systemctl enable telegraf
systemctl restart telegraf