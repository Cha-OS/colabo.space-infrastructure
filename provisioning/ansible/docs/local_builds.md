# Info

This playbook clones git repos to the remote hosts and sets the folders and files privileges

Currently, it supports:
+ angular framework
  + it builds code for final deployment server

# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/gits.yml
```

# Examples

```json
    // build Angular frontend app
    {
        // name of the dashboard
        "key": "litterra-dashboard",
        // local path to the dashboard
        "path": "../../../../infrastructure-2/semanticMediator/src/frontend/apps/ace-mediator/",
        // online path (deeplink) to the dashboard
        "basehref": "/dashboard/",
        // only for `colaboflow` tag or general (non-tags provided)
        "_tags": [
            "colaboflow"
        ]
    }
```
