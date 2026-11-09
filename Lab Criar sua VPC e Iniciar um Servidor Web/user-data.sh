#!/bin/bash

# Instalar o Apache e o PHP
yum install -y httpd mysql php

# Baixar e extrair os arquivos da aplicação do laboratório
wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-100-RESTRT-1/267-lab-NF-build-vpc-web-server/s3/lab-app.zip
unzip lab-app.zip -d /var/www/html/

# Habilitar e iniciar o Apache
chkconfig httpd on
service httpd start
