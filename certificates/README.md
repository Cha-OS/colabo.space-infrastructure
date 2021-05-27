# Shortly sumarrized

## Certificates

### Updating

see [certificate.md](./certificate.md#Updating)

### Installing

```sh
cd /etc/nginx
sudo mkdir letsencrypt
cd letsencrypt
sudo wget https://dl.eff.org/certbot-auto
sudo chmod a+x certbot-auto
mkdir -p /var/www/ac-mediator/letsencrypt

```
### Generating certificate

```sh
sudo joe /etc/nginx/sites-available/ac-mediator

# This is just for us to test if NGINX is configured properly
# cert-bot creates `.well-known/acme-challenge/` folder automatically and removes it afterwards, together with challenges
mkdir -p /var/www/ac-mediator/letsencrypt/.well-known/acme-challenge/
echo "acme test" > /var/www/ac-mediator/letsencrypt/.well-known/acme-challenge/acme-test.html
cat /var/www/ac-mediator/letsencrypt/.well-known/acme-challenge/acme-test.html

# open the link and see if you can access the document
http://m2.audiocommons.org/.well-known/acme-challenge/acme-test.html
```

### Issuing certificates

```sh
#create certificate
cd /etc/nginx/letsencrypt
sudo ./certbot-auto certonly --agree-tos -m chaos.ngo@gmail.com --webroot -w /var/www/ac-mediator/letsencrypt -d m2.audiocommons.org
```

### Setting up certificate and SSL

```sh
sudo joe /etc/nginx/sites-available/ac-mediator
#<START>
server {
  # NEW PART
  listen 443 ssl;
  listen [::]:443 ssl; 

  # NEW PART
  ssl_certificate /etc/letsencrypt/live/m2.audiocommons.org/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/m2.audiocommons.org/privkey.pem;
  ssl_trusted_certificate /etc/letsencrypt/live/m2.audiocommons.org/chain.pem;

 location / {
    try_files $uri $uri/ /index.html;
  }

  # Allow the letsencrypt ACME Challenge
  # this is where letsencrypt will drop the callenge
  location /.well-known/acme-challenge/ {
    root /var/www/ac-mediator/letsencrypt/;
    default_type 'text/plain';
    allow all;
  }
}

# NEW PART
server {
  listen 80; 
  listen [::]:80; 
  server_name m2.audiocommons.org;
  return 301 https://m2.audiocommons.org$request_uri;
}
#<END>

# check config
sudo nginx -t -c /etc/nginx/nginx.conf
# restart new way
sudo service nginx reload
# or restart old way
sudo systemctl restart nginx.service
# if problems check
sudo tail /var/log/nginx/error.log

# Testing

Testing connections:

```sh
ansible all -i variables/hosts.yaml -u ansible --private-key ~/.ssh/orchestration-iaas-no.pem -m ping
```

+ **--check**: run in **dry mode** (just to see what it can do)

```sh
ansible --check all -i hosts.yaml -u ansible --private-key ~/.ssh/orchestration-iaas-no.pem -m ping
```

# SSL

Let’s Encrypt
+ https://letsencrypt.org/
+ Let’s Encrypt is a free, automated, and open Certificate Authority.
+ In order to get a certificate for your website’s domain from Let’s Encrypt, you have to demonstrate control over the domain. With Let’s Encrypt, you do this using software that uses the ACME protocol, which typically runs on your web host.
+ Automate
  + We recommend that most people with shell access use the Certbot ACME client. It can automate certificate issuance and installation with no downtime. It also has expert modes for people who don’t want autoconfiguration. It’s easy to use, works on many operating systems, and has great documentation.

ACME
+ https://ietf-wg-acme.github.io/acme/draft-ietf-acme-acme.html
+ Automatic Certificate Management Environment (ACME)

Certbot
+ https://certbot.eff.org/
+ Automatically enable HTTPS on your website with EFF's Certbot, deploying Let's Encrypt certificates
+ https://certbot.eff.org/docs/install.html
+ https://certbot.eff.org/lets-encrypt/ubuntuartful-nginx
+ https://certbot.eff.org/all-instructions
+ https://certbot.eff.org/docs/intro.html#understanding-the-client-in-more-depth
+ https://certbot.eff.org/docs/using.html#renewal


[Automating SSL Encryption for Your Servers with LetsEncrypt and Ansible](https://www.codementor.io/slavko/automating-ssl-encryption-for-your-servers-with-letsencrypt-and-ansible-vg7jyjot6)

Wildcard
+ [Generating letsencrypt wildcard certificate with certbot](https://www.codementor.io/slavko/generating-letsencrypt-wildcard-certificate-with-certbot-hts4aee8u)

Docker
+ https://github.com/gilyes/docker-nginx-letsencrypt-sample
+ https://github.com/umputun/nginx-le

certificate-based-user-authentication
+ https://community.letsencrypt.org/t/certificate-based-user-authentication/22236
+ https://medium.com/@sevcsik/authentication-using-https-client-certificates-3c9d270e8326

## Manual approach

[HTTPS with Letsencrypt on nginx](https://www.paulpepper.com/blog/2017/03/https-with-letsencrypt-on-nginx/)
+ I used this one
[Letsencrypt friendly nginx configuration](https://imil.net/blog/2016/03/12/Letsencrypt-friendly-nginx-configuration/)

[root directive](http://nginx.org/en/docs/http/ngx_http_core_module.html#root)
[alias directive](http://nginx.org/en/docs/http/ngx_http_core_module.html#alias)

Let's create folders and download certbot-auto:

### Installing

```sh
cd /etc/nginx
sudo mkdir letsencrypt
cd letsencrypt
sudo wget https://dl.eff.org/certbot-auto
sudo chmod a+x certbot-auto
mkdir -p /var/www/fv/letsencrypt

### Generating certificate

Set your NGINX virtual folder. 

It should
+ have `/.well-known/acme-challenge/` folder directed correctly for 
+ certbot-auto to talk with CA authority through acme protocol
+ create challenges in it and let CA confirm in that way we have authorization rights on our (sub)domain

```sh
sudo joe /etc/nginx/sites-available/fv
#<START>

server { 
  listen 80; 
  listen [::]:80; 

  server_name fv.colabo.space;

  root /var/www/fv;
  index index.html;
  autoindex on;

  location / {
    try_files $uri $uri/ /index.html;
  }

  # NEW PART
  # Allow the letsencrypt ACME Challenge
  # this is where letsencrypt will drop the callenge
  location /.well-known/acme-challenge/ {
    root /var/www/ac-mediator/letsencrypt/;
    default_type 'text/plain';
    allow all;
  }
#<END>
}
# check config
sudo nginx -t -c /etc/nginx/nginx.conf
# restart new way
sudo service nginx reload
# or restart old way
sudo systemctl restart nginx.service

# This is just for us to test if NGINX is configured properly
# cert-bot creates `.well-known/acme-challenge/` folder automatically and removes it afterwards, together with challenges
mkdir -p /var/www/fv/letsencrypt/.well-known/acme-challenge/
echo "acme test" > /var/www/fv/letsencrypt/.well-known/acme-challenge/acme-test.html
cat /var/www/fv/letsencrypt/.well-known/acme-challenge/acme-test.html

# open the link and see if you can access the document
http://fv.colabo.space/.well-known/acme-challenge/acme-test.html
# if problems check
sudo tail /var/log/nginx/error.log
```

If above works fine we are good to issue certificate

### Issuing certificates

Relevant folders: `/var/log/letsencrypt`, `/etc/letsencrypt`, `/var/lib/letsencrypt`

```sh
#create certificate
cd /etc/nginx/letsencrypt
sudo ./certbot-auto certonly --agree-tos -m chaos.ngo@gmail.com --webroot -w /var/www/fv/letsencrypt -d fv.colabo.space
```

report:

```txt
IMPORTANT NOTES:
 - Congratulations! Your certificate and chain have been saved at:
   /etc/letsencrypt/live/fv.colabo.space/fullchain.pem
   Your key file has been saved at:
   /etc/letsencrypt/live/fv.colabo.space/privkey.pem
   Your cert will expire on 2018-10-16. To obtain a new or tweaked
   version of this certificate in the future, simply run certbot-auto
   again. To non-interactively renew *all* of your certificates, run
   "certbot-auto renew"
```

If successful, then new key and certificate files should have been created under /etc/letsencrypt/live/fv.colabo.space after running the above command

If there are problems check:
```sh
check for the certbot-auto errors
sudo tail /var/log/letsencrypt/letsencrypt.log
# check for the nginx access errors
sudo tail /var/log/nginx/error.log
```

BTW, these are examples of challenges that are created with certbot-auto inside the `/var/www/fv/letsencrypt/.well-known/acme-challenge/` and are accessed as:

```md
http://fv.colabo.space/.well-known/acme-challenge/jZIGiG4ffvEwuzMSmcOsfxMEjmPhQJkpVso6h4rORKg
http://fv.colabo.space/.well-known/acme-challenge/AqNenJVezWadgsxJK4-uWsmBvNVjJnOdfuf3K7UdQWU
```

### Setting up certificate and SSL

```sh
sudo joe /etc/nginx/sites-available/fv
#<START>
server {
  # NEW PART
  listen 443 ssl;
  listen [::]:443 ssl; 

  server_name fv.colabo.space;

  root /var/www/fv;
  index index.html;
  autoindex on;

  # include custom-conf/restrictions.conf;

  # NEW PART
  ssl_certificate /etc/letsencrypt/live/fv.colabo.space/fullchain.pem;
  ssl_certificate_key /etc/letsencrypt/live/fv.colabo.space/privkey.pem;
  ssl_trusted_certificate /etc/letsencrypt/live/fv.colabo.space/chain.pem;

 location / {
    try_files $uri $uri/ /index.html;
  }

  # Allow the letsencrypt ACME Challenge
  # this is where letsencrypt will drop the callenge
  location /.well-known/acme-challenge/ {
    root /var/www/fv/letsencrypt/;
    default_type 'text/plain';
    allow all;
  }
}

# NEW PART
server {
  listen 80; 
  listen [::]:80; 
  server_name fv.colabo.space;
  return 301 https://fv.colabo.space$request_uri;
}
#<END>

# check config
sudo nginx -t -c /etc/nginx/nginx.conf
# restart new way
sudo service nginx reload
# or restart old way
sudo systemctl restart nginx.service
# if problems check
sudo tail /var/log/nginx/error.log

```

try to go to regular page: ``

### Key Renewal

The certbot documentation recommends running a cron job twice per day to renew certificates. Let’s Encrypt will only renew certificates if they are due to expire, so it’s safe and good practice to run the renewal frequently.

```sh
sudo joe /etc/cron.d/letsencrypt                     
#<START>
# Run the letsencrypt renewal service using certbot-auto.
# once per day at 6:08am
 8 06 * * * root /etc/nginx/letsencrypt/certbot-auto renew --no-self-upgrade --post-hook '/bin/systemctl reload nginx.service'
#</END>
```

***IMPORTANT***: folder `letsencrypt` should exist in the web root that you asking certificate for. Example: `/var/www/fv/letsencrypt/`

## Automatic approach

## Additional domains on the colabo.space NGINX server

+ https://certbot.eff.org/docs/using.html#webroot

P.S. certificates (credentials, keys, ...) are stored in: `/etc/letsencrypt/live/`

```sh
# 1. CREATING ALL FILES

mkdir -p /var/www/colabo/letsencrypt/
mkdir -p /var/www/fv/letsencrypt/
mkdir -p /var/www/topichat/letsencrypt/
mkdir -p /var/www/colaboarthon/letsencrypt/

echo "Hello from colaboarthon!" > /var/www/colabo/index.html
echo "Hello from ForumVlasina!" > /var/www/fv/index.html
echo "Hello from TopiChat!" > /var/www/topichat/index.html
echo "Hello from colaboarthon!" > /var/www/colaboarthon/index.html

sudo joe /etc/nginx/sites-available/colabo
sudo joe /etc/nginx/sites-available/fv
sudo joe /etc/nginx/sites-available/topichat
sudo joe /etc/nginx/sites-available/colaboarthon

sudo joe /etc/nginx/sites-available/initial-colabo
sudo joe /etc/nginx/sites-available/initial-fv
sudo joe /etc/nginx/sites-available/initial-topichat
sudo joe /etc/nginx/sites-available/initial-colaboarthon

# 2. ISSUING CERTIFICATES

sudo rm /etc/nginx/sites-enabled/colabo
sudo rm /etc/nginx/sites-enabled/fv
sudo rm /etc/nginx/sites-enabled/topichat
sudo rm /etc/nginx/sites-enabled/colaboarthon

sudo ln -s /etc/nginx/sites-available/initial-colabo /etc/nginx/sites-enabled/initial-colabo
sudo ln -s /etc/nginx/sites-available/initial-fv /etc/nginx/sites-enabled/initial-fv
sudo ln -s /etc/nginx/sites-available/initial-topichat /etc/nginx/sites-enabled/initial-topichat
sudo ln -s /etc/nginx/sites-available/initial-colaboarthon /etc/nginx/sites-enabled/initial-colaboarthon

# check config
sudo nginx -t -c /etc/nginx/nginx.conf
# restart new way
sudo service nginx reload

# DO ISSUE CERTIFICATE
sudo ./certbot-auto certonly ...

# 3. SETUP AFTER ISSUING CERTIFICATES

sudo rm /etc/nginx/sites-enabled/initial-fv
sudo rm /etc/nginx/sites-enabled/initial-colabo
sudo rm /etc/nginx/sites-enabled/initial-topichat

sudo ln -s /etc/nginx/sites-available/fv /etc/nginx/sites-enabled/fv
sudo ln -s /etc/nginx/sites-available/topichat /etc/nginx/sites-enabled/topichat
sudo ln -s /etc/nginx/sites-available/colabo /etc/nginx/sites-enabled/colabo

# check config
sudo nginx -t -c /etc/nginx/nginx.conf

# restart new way
sudo rm /var/log/nginx/error.log
sudo touch /var/log/nginx/error.log
sudo rm /var/log/nginx/access.log
sudo touch /var/log/nginx/access.log
sudo service nginx reload
# or restart old way
sudo systemctl restart nginx.service
# if problems check
sudo tail /var/log/nginx/error.log
sudo tail /var/log/nginx/access.log

sudo ls -al /var/log/nginx/topichat.access.log
sudo tail /var/log/nginx/topichat.error.log
sudo tail /var/log/nginx/topichat.access.plus.log
```

try to go to the regular page: ``


```

### Issuing certificates

Extend certificates with: 
```sh

-w /var/www/<shortname-domain>/letsencrypt -d <domain1> -d <domain2> \
```

```sh
#create certificate
cd /etc/nginx/letsencrypt

sudo ./certbot-auto certonly --staging --break-my-certs --agree-tos -m chaos.ngo@gmail.com --webroot \
-w /var/www/colabo/letsencrypt -d colabo.colabo.space \
-w /var/www/fv/letsencrypt -d fv.colabo.space \
-w /var/www/topichat/letsencrypt -d topichat.colabo.space

sudo ./certbot-auto certonly --agree-tos -m chaos.ngo@gmail.com --webroot \
-w /var/www/colabo/letsencrypt -d colabo.colabo.space \
-w /var/www/fv/letsencrypt -d fv.colabo.space \
-w /var/www/topichat/letsencrypt -d topichat.colabo.space
```

You can add the flag ` --staging --break-my-certs ` to increase access limits

## Additional domains on the cha-oa.org NGINX server

```sh
# 1. CREATING ALL FILES

sudo joe /etc/nginx/sites-available/chaos

sudo joe /etc/nginx/sites-available/initial-chaos

# 2. ISSUING CERTIFICATES

sudo rm /etc/nginx/sites-enabled/chaos

sudo ln -s /etc/nginx/sites-available/initial-chaos /etc/nginx/sites-enabled/initial-chaos

# check config
sudo nginx -t -c /etc/nginx/nginx.conf
# restart new way
sudo service nginx reload

# DO ISSUE CERTIFICATE
cd /etc/nginx/letsencrypt
# try on stagging to increase access limits
sudo ./certbot-auto certonly --staging --break-my-certs --agree-tos -m chaos.ngo@gmail.com --webroot \
-w /var/www/chaos/letsencrypt -d colabo.cha-os.org
#create certificate
sudo ./certbot-auto certonly --agree-tos -m chaos.ngo@gmail.com --webroot \
-w /var/www/chaos/letsencrypt -d colabo.cha-os.org

# 3. SETUP AFTER ISSUING CERTIFICATES

sudo rm /etc/nginx/sites-enabled/initial-chaos

sudo ln -s /etc/nginx/sites-available/chaos /etc/nginx/sites-enabled/chaos

# check config
sudo nginx -t -c /etc/nginx/nginx.conf

# restart new way
sudo rm /var/log/nginx/error.log
sudo touch /var/log/nginx/error.log
sudo rm /var/log/nginx/access.log
sudo touch /var/log/nginx/access.log

sudo service nginx reload
# or restart old way
sudo systemctl restart nginx.service

# if problems check
sudo tail /var/log/nginx/error.log
sudo tail /var/log/nginx/access.log
```

try to go to the regular page: ``
