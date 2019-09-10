# Info

This playbook installs ghost blog.

**NOTE**: to make NGINX work well and redirect home to language-related blog and particular blog post you have to do following:

**TODO**: 

Manage injecting passwords in `database.password` parameter

Open NGINX config file (i.e. ``)

1. Comment out the original lines:

```yaml
#  location / {
#    try_files $uri $uri/ /index.html;
#  }
```

2. add redirections

```yaml
# should be changed to the default language

# redirects root to /en/home/
location = / {
    rewrite / /en/home redirect;
}

# should be repeated for each language

# English blog
location = /en {
    rewrite /en /en/home redirect;
}
location = /en/ {
    rewrite /en/ /en/home redirect;
}

# Serbian blog
location = /sr {
    rewrite /sr /sr/home redirect;
}
location = /sr/ {
    rewrite /sr/ /sr/home redirect;
}

# Serbian Cyrilic blog
location = /sr-cyr {
    rewrite /sr-cyr /sr-cyr/home redirect;
}
location = /sr-cyr/ {
    rewrite /sr-cyr/ /sr-cyr/home redirect;
}

# Serbian Latin blog
location = /sr-lat {
    rewrite /sr-lat /sr-lat/home redirect;
}

# should be repeated for each language
location = /sr-lat/ {
    rewrite /sr-lat/ /sr-lat/home redirect;
}

# will be matched only if specific language (blog) is not already matched (`location /en/` or `location /sr/` etc) 
location / {
    # redirecs from `` to `/en`
    # (please see it the `url` in the `ghost-config.j2`)
    # rewrite "//(.*)" "/en/$1"  break;

    if (-f $request_filename) {
        break;
    }

    return 302 $scheme://$host/en$request_uri;
#  try_files $uri /en/$uri; # /en/home;
#   rewrite ^(.*) /en$1 redirect;

}

```

```sh
# check
sudo nginx -t -c /etc/nginx/nginx.conf
# restart
sudo systemctl restart nginx
```

# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/ghost.yml
```

**IMPORTANT**: Currently, password injection is not working. Therefore you should manually, set the passwords in every `database.password` parameter in the `ansible/variables/ghost-list.json` file
**IMPORTANT**: Currently ansible doesn't work fine with prepopulated folders (due to the recursion problem with `` ansible command). Therefore:

1. when creating new blog: remove all other blog items from the `ansible/variables/ghost-list.json` file
    + If the procedure crashes, you should remove whole blog content on the server
    + SSH to the server and remove the ghost folder: `sudo rm -rf /var/www/ghost-colabo` 
2. when you are updating blogs: comment out the whole `- name: Set ghost folders` command from the `ansible/playbooks/ghost.yml` file or even better run only the `update` tasks:

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/ghost.yml --tags update
```

# Uninstalling

```sh
# stop services

# list services
systemctl list-units | grep ghost

# disable services
sudo systemctl disable ghost_ghost-retesla-en.service
sudo systemctl disable ghost_ghost-retesla-sr.service
# find pid for the port
sudo fuser <port>/tcp
# kill process
sudo kill -TERM <pid>

# remove data
sudo rm -fr /var/www/ghost-retesla/
```