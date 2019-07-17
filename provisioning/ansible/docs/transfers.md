# Info

This playbook transfers local files/folders to remote hosts

# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/transfers.yml
```

# Examples

```json
        // transfers directory (recursively) from local to remote machine
        {
            "key": "colabo-business-services",
            "src": "../../../../colabo-business-services/",
            "dest": "/var/services/colabo-business-services/",
            "delete": false,
            "mode": "push",
            "recursive": true,
            "file_owner": "www-data",
            "file_group": "developers",
            "file_mode": "ug=rwX,o=rX,g+s",
            "file_state": "directory",
            "hosts": [
                "services",
                "litterra"
            ]
        },
        // transfers file from local to remote machine
        {
            "key": "colabo-business-services-config",
            "src": "../../../../colabo-business-services/similarity/config-server-remote.json",
            "dest": "/var/services/colabo-business-services/similarity/config-server.json",
            "delete": false,
            "mode": "push",
            "recursive": false,
            "file_owner": "www-data",
            "file_group": "developers",
            "file_mode": "ug=rwX,o=rX,g+s",
            "file_state": "file",
            "hosts": [
                "services",
                "litterra"
            ]
        }
    ```

# Issues

Transfer playbook uses [`synchronize` module](https://docs.ansible.com/ansible/latest/modules/synchronize_module.html) which is wrapper for the `rsync` system command.

It has problems with recreating missing destination folders:
+ [Ansible synchronise fails if parent directories are not already created](https://stackoverflow.com/questions/41961331/ansible-synchronise-fails-if-parent-directories-are-not-already-created)

Therefore, we did a whole new work to isolate folder in the case of file transfer to create it before using `synchronize`