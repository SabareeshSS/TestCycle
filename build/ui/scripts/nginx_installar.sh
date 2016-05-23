#!/bin/bash
add-apt-repository ppa:nginx/stable -y
apt-get update
apt-get install -y nginx nginx-extras pwgen
mv /etc/nginx/nginx.conf /etc/nginx/nginx.conf.bak
rm /etc/nginx/sites-enabled/*
mkdir -p /var/www/syclops
echo "root" > /etc/incron.allow
incrontab /incron-user-table
