#!/bin/bash
yum install httpd -y 
sudo service httpd start
sudo echo "Virtual Server link: ${self.public_dns}" > /var/www/html/index.html 
# sudo echo "Virtual Server link: ??? public dns variable ??? " > /var/www/html/index.html 
