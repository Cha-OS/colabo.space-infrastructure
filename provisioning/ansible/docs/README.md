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

# Installing server before first time deploying

+ users.yml
+ init.yml
+ apts.yml
+ remote_builds.yml
+ nginx.yml
+ node.yml
+ python.yml

# Deploying short

## Backend

```sh

# position yourself to the correct colabo.space repo folder
cd colabo/colabo.space

git pull
git push

# position yourself to the correct ansible folder
cd colabo/colabo.space-infrastructure/provisioning/ansible

ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["instances"]}' playbooks/gits.yml

ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["instances"]}' playbooks/yarns.yml

# WARNING: this will transfer also built frontend
# BE SURE you have RIGHT version built!
# TODO we need to fix it
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["instances"]}' playbooks/transfers.yml

# (re)start backend service
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["instances"]}' playbooks/services.yml

# restart backend
ssh -i ~/.ssh/sasha-iaas-no.pem  mprinc@<host>

sudo systemctl status b-colabo
sudo systemctl stop b-colabo
sudo systemctl status b-colabo
sudo systemctl start b-colabo
sudo systemctl status b-colabo

ps -ax | grep node

# run manually
/usr/bin/nodejs /var/repos/colabo/src/backend/apps/colabo-space/dist/index.js 8001
```

## Frontend

```sh

# position yourself to the correct colabo.space repo folder
cd colabo/colabo.space

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

# position yourself to the correct ansible folder
cd colabo/colabo.space-infrastructure/provisioning/ansible

ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["instances"]}' playbooks/local_builds.yml

# WARNING: this will transfer also backend
# BE SURE you have RIGHT version built!
# TODO we need to fix it
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["instances"]}' playbooks/transfers.yml
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
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ubuntu' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/users.yml

# just checking
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ubuntu' --private-key --check ~/.ssh/orchestratio-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/users.yml

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

## remote builds

This playbook run different sorts of remote build, mainly focusing to non-standard scenarios, where we prefer direct commands to run instead ansible modules. Therefore, each item that is run is a build command

```sh
# real
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/remote_builds.yml

# just checking
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key --check ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/remote_builds.yml

# evaluate
nginx -v
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

## local_builds

This playbook builds projects localy

```sh
# real
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/local_builds.yml

# just checking
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ansible' --check --private-key ~/.ssh/orchestratio-iaas-no.pem  --extra-vars '{"active_hosts_groups": ["services"]}' playbooks/local_builds.yml

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

# Troubleshooting

## apt-get update

### the public key is not available

https://chrisjean.com/fix-apt-get-update-the-following-signatures-couldnt-be-verified-because-the-public-key-is-not-available/

### The following signatures were invalid: EXPKEYSIG 58712A2291FA4AD5 MongoDB 3.6 Release

https://stackoverflow.com/questions/34733340/mongodb-gpg-invalid-signatures

Run `apt-key list`. Search for expired. Like this one

```txt
pub   rsa2048 2015-04-03 [SCEA] [expired: 2018-04-02]
      D0BC 747F D8CA F711 7500  D6FA 3746 C208 A731 7B0F
uid           [ expired] Google Cloud Packages Automatic Signing Key <gc-team@google.com>
```

Run

```sh
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys D0BC747FD8CAF7117500D6FA3746C208A7317B0F
```

to replace the key

### 404  Not Found

Error like:

```txt
Ign:9 http://osl-default-1.clouds.archive.ubuntu.com/ubuntu artful-updates InRelease
Err:10 http://security.ubuntu.com/ubuntu artful-security Release          
  404  Not Found [IP: 91.189.88.173 80]
```

https://futurestud.io/tutorials/how-to-fix-ubuntu-debian-apt-get-404-not-found-repository-errors

```sh
sudo sed -i -e 's/archive.ubuntu.com\|security.ubuntu.com/old-releases.ubuntu.com/g' /etc/apt/sources.list
sudo apt-get dist-upgrade
```

https://askubuntu.com/questions/549777/getting-404-not-found-errors-when-doing-sudo-apt-get-update

# Loging in issues

## Warning: the ECDSA host key for 'xxx' differs from the key for the IP address 'yyy'

https://superuser.com/questions/421004/how-to-fix-warning-about-ecdsa-host-key

```sh
ssh-keygen -R <IP>
```

## WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED!

```Offending ECDSA key in /Users/sasha/.ssh/known_hosts:55```

+ If **YOU** changed server, reinstalled, etc, than you should fix it
+ Otherwise it could be the **man-in-the-middle attack**!!!

```sh
ssh-keyscan -t ecdsa psc-test.colabo.space >> ~/.ssh/known_hosts
```

# Updating distro

It is important to keep it updated, as we might have problems with migrated keys, repositories, etc
We can read warnings ubuntu gives us on loging in

```sh
# showinf current release
lsb_release -a

# updating/upgrading distribution
sudo apt-get dist-upgrade

# updating packages
sudo apt-get update
```

# ColaboFlow

## SDGs

Transfer json SDG files to `/var/www_data/LitTerra/content/gutenberg/services/temp_data` on LitTerra (158.39.75.130)

```sh
# use your credentials
ssh -i ~/.ssh/sasha-iaas-no.pem mprinc@158.39.75.130

cd /var/data/litterra
source python-env3/bin/activate
cd /var/www_data/LitTerra/content/gutenberg/services
ps aux | grep py #ubijam staru verziju similarity_task.py
kill -9 6273
nohup python similarity_task.py & #startujem servis
top #gledm da python padne sa 100+%, znaci da je ucitao model, i tek onda testiram sv_client

python sv_client.py temp_data/sdg-cluster-in.json 3 'sdg'
python sv_client.py temp_data/sdg-cluster-in.json 3 'sdg' > temp_data/sdg-cluster-out.json
cat temp_data/sdgsSelectionsTestOutput.json

python sv_client.py temp_data/sdgsSelectionsTestInput.json 3 'sdg'
python sv_client.py temp_data/sdgsSelectionsTestInput.json 3 'sdg' > temp_data/sdgsSelectionsTestOutput.json
cat temp_data/sdg-cluster-out.json

python sv_client.py sdgsSelectionsTestInput.json 3 'sdg'
python sv_client.py sdgsSelectionsTestInput.json 3 'sdg' 1
```