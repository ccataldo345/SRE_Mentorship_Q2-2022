#!/bin/bash
sudo yum install httpd -y
sudo service httpd start
sudo echo "Welcome to the Private Server!" > /var/www/html/index.html
