#!/bin/bash

SONAR_DB_NAME=sonar
SONAR_DB_USER=sonar
SONAR_DB_PASS=sonar
SONAR_VERSION=sonarqube-8.2.0.32929

# Install Java
yum update
yum remove -y java
yum install -y java-1.8.0-openjdk

# Install PostgreSQL
yum install -y unzip curl
amazon-linux-extras install -y postgresql10 vim epel
yum install -y postgresql-server postgresql-devel
/usr/bin/postgresql-setup --initdb
systemctl enable postgresql
systemctl start postgresql

# Create database & credentials for SonarQube
cat > /tmp/db.sql <<EOF
CREATE USER $SONAR_DB_USER WITH ENCRYPTED PASSWORD '$SONAR_DB_PASS';
CREATE DATABASE $SONAR_DB_NAME OWNER $SONAR_DB_USER;
EOF
sudo -u postgres psql postgres < /tmp/db.sql

# Install SonarQube
wget https://binaries.sonarsource.com/Distribution/sonarqube/$SONAR_VERSION.zip -P /tmp
unzip /tmp/$SONAR_VERSION.zip
mv $SONAR_VERSION sonarqube
mv sonarqube /opt/

# Configure SonarQube to use PostgreSQL
cat > /tmp/sonar.properties <<EOF
sonar.jdbc.username=$SONAR_DB_USER
sonar.jdbc.password=$SONAR_DB_PASS
sonar.jdbc.url=jdbc:postgresql://localhost/$SONAR_DB_NAME
EOF
mv /tmp/sonar.properties /opt/sonarqube/conf/sonar.properties
sed -i 's/#RUN_AS_USER=/RUN_AS_USER=sonar/' /opt/sonarqube/bin/linux-x86-64/sonar.sh
sysctl -w vm.max_map_count=262144

# Start SonarQube
groupadd sonar
useradd -c "Sonar System User" -d /opt/sonarqube -g sonar -s /bin/bash sonar
chown -R sonar:sonar /opt/sonarqube
ln -sf /opt/sonarqube/bin/linux-x86-64/sonar.sh /usr/bin/sonar
cp /tmp/sonar.init.d /etc/init.d/sonar
chmod 755 /etc/init.d/sonar
chkconfig --add sonar
service sonar start