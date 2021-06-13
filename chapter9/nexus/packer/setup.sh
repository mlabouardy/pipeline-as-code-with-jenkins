#!/bin/bash

NEXUS_USERNAME="admin"
NEXUS_PASSWORD="admin123"

echo "Install Java JDK 8"
yum update -y
yum install -y java-1.8.0-openjdk

echo "Install Nexus OSS"
wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz -P /tmp
tar -xvf /tmp/latest-unix.tar.gz
mv nexus-* /opt/nexus
mv sonatype-work /opt/sonatype-work
useradd nexus
chown -R nexus:nexus /opt/nexus/ /opt/sonatype-work/
ln -s /opt/nexus/bin/nexus /etc/init.d/nexus
chkconfig --add nexus
chkconfig --levels 345 nexus on
mv /tmp/nexus.rc /opt/nexus/bin/nexus.rc
echo "nexus.scripts.allowCreation=true" >> nexus-default.properties 
systemctl enable nexus
systemctl start nexus

until $(curl --output /dev/null --silent --head --fail http://localhost:8081); do
    printf '.'
    sleep 2
done

NEXUS_PASSWORD=$(cat /opt/sonatype-work/nexus3/admin.password)

echo "Upload Groovy Script"
curl -v -X POST -u $NEXUS_USERNAME:$NEXUS_PASSWORD --header "Content-Type: application/json" 'http://localhost:8081/service/rest/v1/script' -d @/tmp/repository.json

echo "Execute it"
curl -v -X POST -u $NEXUS_USERNAME:$NEXUS_PASSWORD  --header "Content-Type: text/plain" 'http://localhost:8081/service/rest/v1/script/docker-repository/run'
