# Info

This playbook will create general files and folders necesary for the system to run.


# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/init.yml
```

# Examples

```json
        // creating directory/folder
        {
            "key": "/var/colabo/services",
            "state": "directory",
            "owner": "www-data",
            "group": "developers",
            "mode": "ug=rwx,o=rx,g+s"
        },

        // creating file
        {
            "key": "/var/www/index.html",
            "state": "file",
            "owner": "www-data",
            "group": "developers",
            "mode": "ug=rwx,o=rx,g+s",
            "hosts": [
                "blogs"
            ]
        },

```