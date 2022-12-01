#!/bin/bash -x 

echo "Welcome to Packer"
echo "Installing nginx..."
sudo apt-get update 
sudo apt-get install nginx -y
wait

echo "Create nginx folder"
sudo mkdir /home/wahyu
sudo mv /home/ubuntu/nginx.conf /home/wahyu
sudo cp /home/wahyu/nginx.conf /etc/nginx/sites-available/example
sudo mkdir /var/www/nginx
wait

sudo ln -s /etc/nginx/sites-available/example /etc/nginx/sites-enabled/example
sudo rm /etc/nginx/sites-enabled/default
wait

sudo cp /var/www/html/index* /var/www/nginx/index.html

echo "Installing apache..."
sudo apt-get install ssl-cert -y
sudo apt-get install apache2 apache2-bin apache2-utils mime-support -y
sudo apt-get -f install
wait

echo "Create apache folder"
sudo mkdir /var/www/apache
sudo cp /var/www/html/index.html /var/www/apache/
wait

echo "Configuring Apache port..."
sudo sed -i 's/80/8080/' /etc/apache2/ports.conf
sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/example.conf
sudo sed 's+Document.*+Document /var/www/apache+' /etc/apache2/sites-available/example.conf
wait
sudo sed -i 's+.*80.*+<VirtualHost 127.0.0.1:8080>+' /etc/apache2/sites-available/example.conf
wait