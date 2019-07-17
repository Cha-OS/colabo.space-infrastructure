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
# redirects root to /en/home/
location = / {
    rewrite / /en/home redirect;
}

location = /en {
    rewrite /en /en/home redirect;
}

location = /en/ {
    rewrite /en/ /en/home redirect;
}

# will be mtched only if specific language (blog) is not already matched (`location /en/` or `location /sr/` etc) 
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

# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/ghost.yml
```

# Examples

```json
```
