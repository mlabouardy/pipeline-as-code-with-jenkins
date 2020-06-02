#!/bin/bash
wget https://dl.influxdata.com/telegraf/releases/telegraf-1.14.3-1.x86_64.rpm
yum localinstall -y telegraf-1.14.3-1.x86_64.rpm
service telegraf restart