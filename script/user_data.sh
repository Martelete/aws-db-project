#!/bin/bash

yum update -y
yum install -y httpd.x86_64
yum install telnet -y
systemctl start httpd.service
systemctl enable httpd.service
echo "Hello World from $(hostname -f)" > /var/www/html/index.html