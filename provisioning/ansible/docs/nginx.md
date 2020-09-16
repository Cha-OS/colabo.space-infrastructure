# Info

[Pitfalls and Common Mistakes](https://www.nginx.com/resources/wiki/start/topics/tutorials/config_pitfalls)

This playbook installs nginx and configures all hosts

Each key in the `items_array` represents the folder inside the `/var/www` that will be used 
# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/nginx.yml

 ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' --tags 'create_ssl' playbooks/nginx.yml
```

Example of a running command: `./certbot-auto certonly -n --expand --agree-tos -m chaos.ngo@gmail.com --webroot -w /var/www/ghost-chaos/letsencrypt --cert-name ghost-chaos -d cha-os.org -d www.cha-os.org`

Failed:

Saving debug log to /var/log/letsencrypt/letsencrypt.log
Plugins selected: Authenticator webroot, Installer None
Cert is due for renewal, auto-renewing...
Renewing an existing certificate
An unexpected error occurred:

There were too many requests of a given type :: Error creating new order :: too many failed authorizations recently: see https://letsencrypt.org/docs/rate-limits/

# Useful

```sh
# Checking nginx config file syntax
sudo nginx -t

# Manual restart of the NGINX service:
sudo systemctl restart nginx
```

# Examples

```json
        // will create website (`cha-os.org` with alias `cha-os.org`) 
        // with SSL certificate for both website and alias
        // there is also a need for an extension, `well-known`
        // in order for certbot to install the certificate properly
        {
            "key": "ghost-chaos",
            "host": "cha-os.org",
            "aliases": "www.cha-os.org",
            "web_root": {
                "owner": "www-data",
                "group": "developers",
                "mode": "ug=rwx,o=rx,g+s"
            },
            "certificate": {
                "email": "chaos.ngo@gmail.com",
                "hosts": [
                    "cha-os.org",
                    "www.cha-os.org"
                ]
            },
            "extensions": [{
                    "key": "well-known",
                    "type": "well-known",
                    "placeholder": "server_placeholder"
                }
            ]
        }
```
## Certificates

We support certificates through certbot. They are automatically renewed (NOTE: we used to have problems, so please check if they are renowed. If you get expiration warning email from certbot, that is usually bad sign).

Currently (and proable forever :) ) you HAVE to have certificate for the website! :) Although, it is not complicated to remove that restriction. 

You can:
1. CREATE a new certificate for the website and its aliases

```json
{
    "key": "litterra",
    "host": "litterra.net",
    "aliases": "www.litterra.net litterra.info www.litterra.info",
    // ...
    "certificate": {
        "email": "chaos.ngo@gmail.com",
        "hosts": [
            "litterra.net",
            "www.litterra.net",
            "litterra.info",
            "www.litterra.info",
            "bukvik.litterra.net",
            "bukvik.litterra.info"
        ]
    },
    // ...
}
```

2. you can REFER to other website through its key

```json
{
    "key": "bukvik",
    "host": "bukvik.litterra.net",
    "aliases": "bukvik.litterra.net bukvik.litterra.info",
    // ...
    "certificate_comment": "realized through litterra website certificate",
    "certificate_reference": "litterra",
    // ...
}
```

**IMPORTANT**: In this case we have to extend the refered certificate with all aliases hosts of the website that refers to another host's certificate

### Issues

General advice:
```sh
sudo tail -n 100 /var/log/letsencrypt/letsencrypt.log
sudo tail -n 50 /var/log/nginx/error.log
sudo tail -n 100 /var/log/nginx/ghost-litterra.access.log
sudo tail -n 100 /var/log/nginx/ghost-litterra.access.plus.log
sudo tail -n 100 /var/log/nginx/ghost-litterra.error.log

# ssl_certificate
sudo cat /etc/letsencrypt/live/ghost-litterra/fullchain.pem

# ssl_certificate_key
sudo cat /etc/letsencrypt/live/ghost-litterra/privkey.pem

# ssl_trusted_certificate
sudo cat /etc/letsencrypt/live/ghost-litterra/chain.pem;

# /.well-known/acme-challenge/
ls -al /var/www/ghost-litterra/letsencrypt/

sudo systemctl restart nginx
```

#### To many sites-available

+ check the `/etc/nginx/sites-available` if there are any duplicated or wrongly dirtected sites, as that might be missleading for the certbot

## Extensions

There are various extensions that are supporting particular use cases with building website support through NGINX, like SSH certificates, ghost blog, API support, redirection, etc.S

```json
// `well-known` extension is used for certbot SSL certificates to work properly
{
    "key": "well-known",
    "type": "well-known",
    "placeholder": "server_placeholder"
},

// `ghost` extension installs NGINX support for the ghost blog
{
    "key": "ghost-en",
    "type": "ghost",
    // should be redirected to from the default page (ie. http://colabo.space -> https://colabo.space/en/home)
    "main": true,
    "placeholder": "server_placeholder",
    "language": "en",
    "port": 25000
},

// `redirect` extension is used to provide support for redirection of urls (deeplinks) in NGINX supported websites
// redirects any link that is not starting with language prefix (so either /en* or /sr* in this case) to the same link prefixed with the default lanugage (/sr in this case)
{
    "key": "ghost-redirect",
    "type": "redirect",
    "placeholder": "server_placeholder",
    // https://stackoverflow.com/questions/16302897/nginx-location-not-equal-to-regex
    "from": "^/(?!(en|sr))",
    "to": "/sr$request_uri"
},

// `api` extension is used to provide support for api (redirecting, proxying, passing/forwarding to the port, ...)
{
    "key": "api",
    "api_path": "api",
    "proxy_pass": "http://127.0.0.1:9027",
    "placeholder": "server_placeholder"
}
```