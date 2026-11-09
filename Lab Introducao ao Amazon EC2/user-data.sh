#!/bin/bash
# Instala e habilita o Apache HTTP Server e publica uma página de teste
# Script fornecido para execução no campo Advanced details > User data

yum -y install httpd
systemctl enable httpd
systemctl start httpd
echo '<html><h1>Hello From Your Web Server!</h1></html>' > /var/www/html/index.html
