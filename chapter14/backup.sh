#!/bin/bash

cd $JENKINS_HOME
BACKUP_TIME=$(date +'%m.%d.%Y')
zip -r backup-${BACKUP_TIME} .
aws s3 cp  backup-${BACKUP_TIME} s3://BUCKET/