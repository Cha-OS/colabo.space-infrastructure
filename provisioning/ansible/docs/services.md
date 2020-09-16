# Info

This playbook creates, registers and starts all necessary system services (with SystemD)

# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/services.yml
```

# Test

```sh
# example for the service `b-colabo` 
# in `colabo.space-infrastructure/provisioning/ansible/variables/services-list.json`
sudo systemctl status b-colabo
sudo systemctl stop b-colabo
# working_dir
cd /var/repos/colabo/src/backend/apps/colabo-space/dist/
# exec_start
/usr/bin/nodejs /usr/bin/nodejs /var/repos/colabo/src/backend/apps/colabo-space/dist/index.js 8001
sudo systemctl start b-colabo
```

# Examples

## MySQL

```json
```