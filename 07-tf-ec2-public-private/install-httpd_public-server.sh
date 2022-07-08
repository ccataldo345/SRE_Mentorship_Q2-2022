#!/bin/bash
yum install httpd -y
sudo service httpd start
sudo echo "Welcome to the Public Server!" > /var/www/html/index.html
