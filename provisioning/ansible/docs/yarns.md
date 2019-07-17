# Info

This playbook installs remote npm packages with `yarn`

# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/yarns.yml
```

# Issues

If you get error with this playbook, it is mostlikely due to the system package `cmdtest`. In that case, we need to remove it and try again.

```sh
# remove problematic `cmdtest` apt package that has `yarn` command
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/apts.yml

# install proper `yarn` packge
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/node.yml

# install npm packages
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/yarns.yml
```

# Examples

```json
        // installs (globally) package `typescript`
        {
            "key": "typescript",
            "name": "typescript",
            "global": true,
            "production": false,
            "state": "present"
        },
        // builds packages for the project in `/var/repos/colabo/src/isomorphic/package.json`
        {
            "key": "colabo-isomorphic",
            "comment": "build (yarn) isomorphic puzzles",
            "name": "",
            "global": false,
            "path": "/var/repos/colabo/src/isomorphic",
            "production": false,
            "state": "present",
            "hosts": [
                "instances",
                "services",
                "litterra"
            ]
        },

    ```