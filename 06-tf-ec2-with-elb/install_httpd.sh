#!/bin/bash
yum install httpd -y 
sudo service httpd start
DNS=$(curl -s http://169.254.169.254/latest/meta-data/public-hostname)
sudo echo "Virtual Server link: $DNS" > /var/www/html/index.html 
