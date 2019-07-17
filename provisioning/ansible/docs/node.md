# Info

This playbook installs node, build tools and yarn

# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/node.yml
```

# Examples

There are no any special configuration parameters in the `node-list.json`