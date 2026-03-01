#!/bin/bash
apt-get update -y
apt-get install -y amazon-efs-utils
mkdir -p /var/www/html
mount -t efs ${efs_id}:/ /var/www/html
echo "${efs_id}:/ /var/www/html efs defaults,_netdev 0 0" >> /etc/fstab