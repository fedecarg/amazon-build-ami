#!/bin/bash

# Heartbeat
# Federico Cargnelutti <fedecarg@gmail.com>

EMAIL="fedecarg@gmail.com"
DATETIME=$(date '+%d-%m-%Y %H:%M:%S')

AMI_HOSTNAME=`curl -s http://169.254.169.254/latest/meta-data/hostname`
AMI_PUBLIC_HOSTNAME=`curl -s http://169.254.169.254/latest/meta-data/public-hostname`
AMI_PUBLIC_IP=`curl -s http://169.254.169.254/latest/meta-data/public-ipv4`

api_params="key=0000&project=name&environment=prd&datetime=${DATETIME}"
ec2_params="public_ip=${AMI_PUBLIC_IP}&public_hostname=${AMI_PUBLIC_HOSTNAME}&private_hostname=${AMI_HOSTNAME}&host=${HOSTNAME}"
curl http://domain/api/heartbeat --data "$api_params" --data "$ec2_params"
