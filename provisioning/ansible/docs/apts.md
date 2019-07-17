# Info

This playbook installs apps via `apt` (Linux, like Ubuntu distro, etc)


# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/apts.yml
```

# Examples

```json

        // remove `cmdtest` package
        {
            "key": "cmdtest",
            "state": "absent"
        },

        // install `joe` editor
        {
            "key": "joe",
            "state": "present"
        },

        // install multiple python packages
        // tag them as `python` (run when no tags provided or when `python` tag specified)
        {
            "key": [
                "python",
                "python-pip",
                "python3",
                "python3-pip",
                "python3-virtualenv",
                "python-virtualenv",
                "virtualenv"
            ]
            "state": "present",
            "_tags": [
                "python"
            ]
        },

        // install multiple mysql packages
        // tag them as `mysql` (run when no tags provided or when `mysql` tag specified)
        // provide the list of `hosts` for which to install packages
        {
            "key": [
                "mysql-server",
                "mysql-client",
                "python3-pymysql",
                "python-pymysql"
            ],
            "state": "present",
            "_tags": [
                "mysql"
            ],
            "hosts": [
                "blogs",
                "litterra"
            ]
        },
```
