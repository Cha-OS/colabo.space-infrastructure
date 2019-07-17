# Info

This playbook run different sorts of remote build, mainly focusing to non-standard scenarios, where we prefer direct commands to run instead ansible modules. Therefore, each item that is run is a build command

# TODO

- Seems it makes problem when `user` is not set
- Also `apt-get install -y mongodb-org`

# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/remote_builds.yml
```

# Examples

```json
        // builds similarity service, by running `setup.py` script 
        {
            "key": "similarity-build",
            "user": "www-data",
            "path": "/var/services/colabo-business-services/",
            "command": "/var/services/colabo-env-python2/bin/python2 /var/services/colabo-business-services/similarity/setup.py",
            "_tags": [
                "service",
                "similarity"
            ],
            "hosts": [
                "services"
            ]
        }
```

For more examples, please check the JSON instructions file: `ansible/playbooks/remote_builds.yml`