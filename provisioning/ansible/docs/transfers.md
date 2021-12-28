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

## missing destination folders

Transfer playbook uses [`synchronize` module](https://docs.ansible.com/ansible/latest/modules/synchronize_module.html) which is wrapper for the `rsync` system command.

It has problems with recreating missing destination folders:
+ [Ansible synchronise fails if parent directories are not already created](https://stackoverflow.com/questions/41961331/ansible-synchronise-fails-if-parent-directories-are-not-already-created)

Therefore, we did a whole new work to isolate folder in the case of file transfer to create it before using `synchronize`

## Error syncing

For a mix of errors we were getting errors where underlying `rsync` command was breaking connection on a file transfer. When we removed the item before the one on which it was breaking it worked, which indicates that **the error is not directed enough**.

Solution was mixed (not clear):
+ changing `"file_mode": "ug=rwX,o=rX,g+s",` into `"file_mode": "ug=rwX,o=rX",` for files
+ removing content of all destination folders
+ setting destination folders' users, groups and privileges to the expected one

We replicated error with:

```sh
# https://linuxize.com/post/how-to-transfer-files-with-rsync-over-ssh/
# https://www2.nrel.colostate.edu/projects/irc/public/Documents/KnowledgeBase/HowTo_SSH_DSA_Key.htm
rsync -a -P -e "ssh -i ~/.ssh/orchestration-iaas-no.pem" ../../../tickerai-infrastructure-private/provisioning/files/backend/global-server.js ansible@tickerai.io:/var/services/tickerai-apps-backend/config/global.js
```

and we got error for file privileges (but it could be due to not having right user/group set as for the ansible scenario)
