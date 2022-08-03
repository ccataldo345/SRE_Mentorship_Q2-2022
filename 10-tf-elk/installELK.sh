#!/bin/bash
sudo apt update && sudo apt-get upgrade -y
sudo apt-get install default-jre -y
sudo java -version

# install elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-... | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://artifacts.elastic.co/packages... stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
sudo apt-get update
sudo apt-get install elasticsearch -y
sleep 10
sudo service elasticsearch start
sudo curl http://localhost:9200

# instll logstash
sudo apt-get install logstash
sleep 10

# install kibana
sudo apt-get install kibana
sleep 10

sudo mv /tmp/kibana.yml /etc/kibana/kibana.yml
sudo service kibana start

# install metricbeat
sudo apt-get install metricbeat
sleep 10
sudo service metricbeat start

# start logstash
sudo mv /tmp/apache.conf /etc/logstash/conf.d/apache.conf
sleep 15
sudo service logstash start

# install nginx
sudo apt-get install nginx -y
sleep 10
sudo mv /tmp/zztalks.xyz /etc/nginx/sites-available/zztalks.xyz
sudo ln -s /etc/nginx/sites-available/zztalks.xyz /etc/nginx/sites-enabled/
sudo service nginx restart
