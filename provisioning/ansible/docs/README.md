# TODO

## Provide support for `_tags` in JSON instructions files

Replace

```yaml
when: "{{ item.hosts is not defined or ((active_hosts_groups | intersect(item.hosts)) | length>0) }}" # check `hosts` matching
```

with

```yaml
when: "{{ (item.hosts is not defined or ((active_hosts_groups | intersect(item.hosts)) | length>0) ) and (active_tags is not defined or ((active_tags | intersect(item._tags)) | length>0) ) }}" # check `hosts` and `_tags` matching
```

# Deploying short

## Backend

```sh

git pull
git push

ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/gits.yml

ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/yarns.yml

# WARNING: this will trnsfer also built frontend
# BE SURE you have RIGHT version built!
# TODO we need to fix it
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/transfer.yml

# restart backend
ssh -i ~/.ssh/sasha-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' mprinc@158.39.75.120

sudo systemctl status knalledge-b
sudo systemctl stop knalledge-b
sudo systemctl status knalledge-b
sudo systemctl start knalledge-b
sudo systemctl status knalledge-b

ps -ax | grep node

# run manually
/usr/bin/nodejs /var/repos/colabo/src/backend/apps/colabo-space/dist/index.js 8001
```

## Frontend

```sh

git pull

# if necessary, but still better every time
colabo/src/isomorphic
yarn

# if necessary, but still better every time
colabo/src/frontend
yarn

# if necessary, but still better every time
colabo/src/frontend/apps/psc
yarn

ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/local_builds.yml

# WARNING: this will trnsfer also backend
# BE SURE you have RIGHT version built!
# TODO we need to fix it
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/transfers.yml
```
## Services

```sh
ssh -i ~/.ssh/sasha-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' mprinc@158.39.75.130
ps -ax | grep python

cd /var/colabo
ls -alt /var/colabo
ls -alt /var/services/colabo-business-services/similarity/
cd /var/services/colabo-business-services/similarity/
/var/services/colabo-env-python2/bin/python2 /var/services/colabo-business-services/similarity/similarity_functions.py

sudo systemctl status s-similarity
sudo systemctl stop s-similarity
sudo systemctl start s-similarity

# run manually
cd /var/services/colabo-business-services/similarity/
/var/services/colabo-env-python2/bin/python2 /var/services/colabo-business-services/similarity/similarity_functions.py
sudo kill -TERM <pid>
```

Local:

```sh
/usr/local/sbin/rabbitmq-server
```

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
ansible all -i variables/hosts.yaml -u ansible --private-key ~/.ssh/orchestration-iaas-no.pem  --exta-vars '{"active_hosts_groups": ["services"]}' -m ping
```

+ **--check**: run in **dry mode** (just to see what it can do)

```sh
ansible --check all -i hosts.yaml -u ansible --private-key ~/.ssh/orchestration-iaas-no.pem  --exta-vars '{"active_hosts_groups": ["services"]}' -m ping
```

# Structure

+ playbooks are under the `playbooks` folder
+ templates are under the `templates` folder
+ variables are under the `variables` folder
    + `hosts.yaml` is a special file containing all hosts organized in groups. It is inventory file
    + `empty.json` is a special safe fall-drop file when we are iterating over different files to avoid error

# Playbooks

Each playbook comes with associated variables in the same-name varables file stored in the `variables` folder.

Each playbook can in addition have 

## Users

This playbook creates all users in the cluster, sets up their privileges, credentials, sets private keys, etc.

```sh
# real
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/users.yml

# just checking
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key --check ~/.ssh/orchestratio-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/users.yml

# Evaluate
ls -al /home
cat /etc/sudoers.d/95-no-pass-users
```

## init

This playbook setup initial server state

+ creates all folders

```sh
# real
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/init.yml

# just checking
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key --check ~/.ssh/orchestratio-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/init.yml

# evaluate
ls -al /var/www
ls -al /var/services
ls -al /var/repos
```

## apps

This playbook installs apps via `apt`

```sh
# real
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/apts.yml

# just checking
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key --check ~/.ssh/orchestratio-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/apts.yml

# evaluate
gcc --version
git --version
python --version
python3 --version
```

## nginx

This playbook installs nginx and configures all hosts

```sh
# real
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/nginx.yml

# just checking
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key --check ~/.ssh/orchestratio-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/nginx.yml

# evaluate
nginx -v
ls -al /var/www/
ls -al /var/www/playsound
ls -al /etc/nginx/sites-available/
cat /etc/nginx/sites-available/playsound
ls -al /etc/nginx/sites-enabled/
nginx -t -c /etc/nginx/nginx.conf
sudo systemctl status nginx
```

## node

This playbook installs node, build tools and yarn

```sh
# real
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/node.yml

# just checking
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key --check ~/.ssh/orchestratio-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/node.yml

# evaluate
nodejs -v
npm -v
yarn -v
gcc --version
g++ --version
make --version
```

## gits

This playbook clones git repos to the remote hosts and sets the folders and files privileges

```sh
# real
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/gits.yml

# just checking
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key --check ~/.ssh/orchestratio-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/gits.yml

# evaluate
ls -al /var/repos/PlaySound-Colabo.Space
# NOTE: check owner, group, and file and folder mode
```

## python

This playbook builds python parts of the projects. It works both for python 2 and python 3. It builds virtual environments (`vurtualenv`), packages (`pip`), or requirements (`requirements.txt`).

```sh
# real
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/python.yml

# just checking
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key --check ~/.ssh/orchestratio-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/python.yml

# evaluate
ls -al /var/services/colabo-env-python2/bin
ls -al /var/services/colabo-env-python3/bin
```

## remote builds

This playbook run different sorts of remote build, mainly focusing to non-standard scenarios, where we prefer direct commands to run instead ansible modules. Therefore, each item that is run is a build command


## local_builds

This playbook builds projects localy

```sh
# real
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/local_builds.yml

# just checking
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key --check ~/.ssh/orchestratio-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/local_builds.yml

# evaluate
# NOTE: on local machine
ls -al ./playbooks/../../../src/frontend/apps/PlaySound/dist/play-sound
```

## transfers

This playbook transfers local files/folders to remote hosts

```sh
# real
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/transfers.yml

# just checking
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key --check ~/.ssh/orchestratio-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/transfers.yml

# evaluate
ls -al /var/www/playsound/
ls -al /var/www/playsound/config/global.js
# NOTE: should have server (no localhost) `serverUrl`
cat /var/www/playsound/config/global.js
```

## yarns

This playbook installs remote npm packages with `yarn`

```sh
# real
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/yarns.yml

# just checking
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key --check ~/.ssh/orchestratio-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/yarns.yml

# evaluate
tsc -v
ng --version
colabo
ls -al /var/repos/PlaySound-Colabo.Space/src/backend/apps/play-sound/node_modules
ls -al /var/repos/PlaySound-Colabo.Space/src/backend/apps/play-sound/node_modules/\@audio-commons/
ls -al /var/repos/PlaySound-Colabo.Space/src/backend/apps/play-sound/node_modules/\@colabo-*/
```

## database

This playbook creates databases, database users, etc

```sh
# real
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/database.yml

# just checking
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key --check ~/.ssh/orchestratio-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/database.yml

# evaluate

# see logging
# sudo journalctl -b -e -f -l -u s-similarity.service
```

## services

This playbook creates, registers and starts all necessary system services (with SystemD)

```sh
# real
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/services.yml

# just checking
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key --check ~/.ssh/orchestratio-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/services.yml
# evaluate
ls -al /var/services
cat /var/services/s-similarity.service
ls -al /etc/systemd/system/
sudo systemctl status s-similarity
# see logging
sudo journalctl -b -e -f -l -u s-similarity.service
```

# Final

## Backend

```sh
# from local machine
curl -v -H "Content-Type: application/json" -X GET http://127.0.0.1:8005/search-sounds/bird
# from local machine
curl -v -H "Content-Type: application/json" -X GET http://playsound.colabo.space:8005/search-sounds/bird
# from remote machine
curl -v -H "Content-Type: application/json" -X GET http://playsound.colabo.space/api/search-sounds/bird
```

Or navigate browser to: http://playsound.colabo.space/api/search-sounds/bird

## Frontend

Navigate browser to http://playsound.colabo.space