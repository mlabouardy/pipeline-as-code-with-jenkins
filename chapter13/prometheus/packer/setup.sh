#!/bin/bash

wget https://github.com/prometheus/prometheus/releases/download/v2.18.1/prometheus-2.18.1.linux-amd64.tar.gz
useradd --no-create-home --shell /bin/false prometheus
mkdir /etc/prometheus
mkdir /var/lib/prometheus
chown prometheus:prometheus /etc/prometheus
chown prometheus:prometheus /var/lib/prometheus
tar -xvf prometheus-2.18.1.linux-amd64.tar.gz
mv prometheus-2.18.1.linux-amd64 prometheus
cp prometheus/prometheus /usr/local/bin/
cp prometheus/promtool /usr/local/bin/
chown prometheus:prometheus /usr/local/bin/prometheus
chown prometheus:prometheus /usr/local/bin/promtool
cp -r prometheus/consoles /etc/prometheus/
cp -r prometheus/console_libraries /etc/prometheus/
chown -R prometheus:prometheus /etc/prometheus/consoles
chown -R prometheus:prometheus /etc/prometheus/console_libraries
mv /tmp/prometheus.yml /etc/prometheus/prometheus.yml
chown -R prometheus:prometheus /etc/prometheus/prometheus.yml
mv /tmp/prometheus.service /etc/systemd/system/prometheus.service
systemctl daemon-reload
systemctl enable prometheus
systemctl start prometheus
