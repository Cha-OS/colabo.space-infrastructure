## Certificates

### Installing

```sh
cd /etc/nginx
sudo mkdir letsencrypt
cd letsencrypt
sudo wget https://dl.eff.org/certbot-auto
sudo chmod a+x certbot-auto
mkdir -p /var/www/ac-mediator/letsencrypt
```

#### Ansible

+ There is a package, but not looking great (need to run 2 phases, manual changes, etc): 
  + https://docs.ansible.com/ansible/2.5/modules/letsencrypt_module.html

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

# Key Renewal

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
