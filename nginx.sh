#!/bin/bash

coinname="ADD COIN NAME"
port="ADD PORT"
domain="$coinname.ADD DOMAIN NAME"

sudo apt update
sudo apt install nginx
sudo ufw allow 'Nginx HTTP'
sudo systemctl enable nginx

sudo rm /etc/nginx/sites-enabled/default
touch /etc/nginx/sites-available/$coinname

echo -e "server {
    listen 80;
    server_name $domain;

    location / {
        proxy_set_header   X-Forwarded-For "$remote_addr";
        proxy_set_header   Host "$http_host";
        proxy_pass         "http://127.0.0.1:$port";
    }
}" > /etc/nginx/sites-available/$coinname

sudo ln -s /etc/nginx/sites-available/$coinname /etc/nginx/sites-enabled/$coinname
sudo systemctl start nginx
ufw limit 22/tcp comment "Limit SSH "
ufw allow 22/tcp comment "SSH"
ufw allow http comment "HTTP"
ufw allow https comment "HTTPS"
sudo add-apt-repository ppa:certbot/certbot
sudo apt install python-certbot-nginx
sudo certbot --nginx -d $domain -d www.$domain
