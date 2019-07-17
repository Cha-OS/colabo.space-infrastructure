# Info

This playbook installs nginx and configures all hosts

Each key in the `items_array` represents the folder inside the `/var/www` that will be used 
# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/nginx.yml
```

# Examples

```json
        // will create website (`cha-os.org` with alias `cha-os.org`) 
        // with SSL certificte for both website and alias
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
    "placeholder": "server_placeholder",
    "language": "en",
    "port": 25000
},

// `redirect` extension is used to provide support for redirection of urls (deeplinks) in NGINX supported websites
{
    "key": "ghost-redirect",
    "type": "redirect",
    "placeholder": "server_placeholder",
    "from": "(.+)",
    "to": "en/$1"
},

// `api` extension is used to provide support for api (redirecting, proxying, passing/forwarding to the port, ...)
{
    "key": "api",
    "api_path": "api",
    "proxy_pass": "http://127.0.0.1:9027",
    "placeholder": "server_placeholder"
}
```