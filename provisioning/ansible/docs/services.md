# Info

This playbook creates, registers and starts all necessary system services (with SystemD)

# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/services.yml
```

# Examples

## MySQL

```json
```