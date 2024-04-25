#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo bash -c 'echo Congratulations! on your first Webserver Installation > /var/www/html/index.html'
