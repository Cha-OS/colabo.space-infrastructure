# Info

This playbook installs node, build tools and yarn

It follows:
https://github.com/nodesource/distributions#debinstall

# TODO

Forbid installing problematic cmdtools:
+ https://askubuntu.com/questions/75895/how-to-forbid-a-specific-package-to-be-installed

# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/node.yml
```

# Examples

There are no any special configuration parameters in the `node-list.json`

# Troubleshooting

## The following packages have unmet dependencies

[How do I resolve `The following packages have unmet dependencies`](https://stackoverflow.com/questions/26571326/how-do-i-resolve-the-following-packages-have-unmet-dependencies)