# https://nehalist.io/installing-ghost-1-0-without-ghost-cli/
# https://docs.ghost.org/api/ghost-cli/config/
# https://docs.ghost.org/concepts/config/

[Installing Second Ghost Instance on Single VPS](https://forum.ghost.org/t/installing-second-ghost-instance-on-single-vps/1116)

# install users
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ubuntu' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/users.yml

# create folders
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/init.yml

# apps
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/apts.yml

# node.js
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/node.yml

# yarns
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/yarns.yml

# remote_builds
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/remote_builds.yml

# NOTE: YOU HAVE TO MANUALLY SET THE ROOT PASSWORD BEFORE THIS, please check in the `playbooks/database.yml` file

# database
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/database.yml

# nginx
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/nginx.yml

    # nginx (without installing tools and SSLs)
    ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/nginx.yml --skip-tags create_ssl,install

    # nginx (only update nginx configs)
    ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/nginx.yml --tags create_nginx_config

# ghost
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/ghost.yml

# services (not used currently)
# ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/services.yml

# Adding new blogs

# database
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/database.yml

# nginx
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/nginx.yml

    # nginx (without installing tools and SSLs)
    ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/nginx.yml --skip-tags create_ssl,install

    # nginx (only update nginx configs)
    ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/nginx.yml --tags create_nginx_config

# ghost
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["blogs"]}' playbooks/ghost.yml

# Other

cd /var/www/ghost-chaos/
mkdir en
cd en
cd /var/www/ghost-chaos/en/
# sudo chown ghost:developers en
ls /etc/systemd/system/
ls /etc/systemd/system/multi-user.target.wants/

ghost install --no-prompt --no-setup

cp ../../ghost/config.production.json .
# change the config.production.json content

sudo chown -R ghost:ghost content
# sudo chown -R ghost:ghost /var/www/ghost-chaos/sr/content
sudo chmod 775 /var/www/ghost
ghost config --no-prompt
sudo find ./ -type d -exec chmod 00775 {} \;
ghost setup linux-user systemd
ghost start --enable

sudo nginx -t -c /etc/nginx/nginx.conf
sudo systemctl status nginx
sudo systemctl restart nginx

# run by systemd
/usr/bin/node /usr/bin/ghost run

# /usr/local/bin/ghost
# /usr/bin/ghost

# config
# https://docs.ghost.org/api/ghost-cli/config/
ghost config --url https://chaos.colabo.space/en --pname ghost-chaos-en --port 25000
ghost config --url https://chaos.colabo.space/sr --pname ghost-chaos-sr --port 25001
ghost config --url https://boradugic.colabo.space/sr-cyr --pname ghost-boradugic-sr-cyr --port 25006 --dbname ghost_boradugic_sr_cyr

http://boradugic.colabo.space/en/
ghost
ghost_boradugic_en

Creating nginx config file at /var/www/ghost-boradugic/en/system/files/boradugic.colabo.space.conf
/etc/nginx/sites-available/boradugic.colabo.space.conf
/etc/nginx/sites-enabled/boradugic.colabo.space.conf

Creating systemd service file at /var/www/ghost-boradugic/en/system/files/ghost_boradugic-colabo-space.service
+ sudo ln -sf /var/www/ghost-boradugic/en/system/files/ghost_boradugic-colabo-space.service /lib/systemd/system/ghost_boradugic-colabo-space.service
+ sudo systemctl daemon-reload

sudo systemctl is-active ghost_boradugic-colabo-space

# =======

http://colabo.colabo.space/en/
ghost
ghost_colabo_en

Creating nginx config file at /var/www/ghost-colabo/en/system/files/colabo.colabo.space.conf
 sudo ln -sf /var/www/ghost-colabo/en/system/files/colabo.colabo.space.conf /etc/nginx/sites-available/colabo.colabo.space.conf
+ sudo ln -sf /etc/nginx/sites-available/colabo.colabo.space.conf /etc/nginx/sites-enabled/colabo.colabo.space.conf

Creating systemd service file at /var/www/ghost-colabo/en/system/files/ghost_colabo-colabo-space.service
+ sudo ln -sf /var/www/ghost-colabo/en/system/files/ghost_colabo-colabo-space.service /lib/systemd/system/ghost_colabo-colabo-space.service

sudo systemctl is-active ghost_ghost-colabo-en.service
sudo systemctl start ghost_ghost-colabo-en.service
sudo systemctl is-enabled ghost_ghost-colabo-en.service
sudo systemctl enable ghost_ghost-colabo-en.service --quiet

# =======

✔ Creating systemd service file at /var/www/ghost-colabo/sr/system/files/ghost_colabo-colabo-space-1.service
+ sudo ln -sf /var/www/ghost-colabo/sr/system/files/ghost_colabo-colabo-space-1.service /lib/systemd/system/ghost_colabo-colabo-space-1.service
+ sudo systemctl daemon-reload
✔ Setting up Systemd

+ sudo systemctl is-active ghost_colabo-colabo-space-1

sudo joe /etc/nginx/sites-available/colabo.colabo.space.conf
added:

    location ^~ /sr/ {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host $http_host;
        proxy_pass http://127.0.0.1:2370;
        proxy_redirect off;
    }



# =======


location / {
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
    proxy_set_header X-Forwarded-Proto $scheme;
    proxy_set_header X-Real-IP $remote_addr;
    proxy_set_header Host $http_host;
    proxy_pass http://127.0.0.1:23650;
}

sudo systemctl restart nginx

# [Pre fill custom configuration values ](https://github.com/TryGhost/Ghost-CLI/issues/268)
# ghost install --no-prompt
# ghost setup --no-prompt
# cp ../ghost/config.production.json .
# ghost config --no-prompt