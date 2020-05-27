# Info

This playbook creates databases, database users, etc

**IMPORTANT**: At the moment there is no automatic injection/replacement of the password, so we need to do it manually in the file `colabo.space-infrastructure/provisioning/ansible/playbooks/database.yml`, but NOT COMMIT the file with the correct password.

`mysql_root_password: "<root_password_placeholder>"` into `mysql_root_password: "correct_password_goes_here"`

**TODO**: 

Manage injecting passwords in `password` parameter

# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/database.yml
```

# Examples

## MySQL

```json
        {
            "key": "database",
            "type": "mysql.database",
            "name": "ghost_colabo_en",
            "hosts": [
                "blogs"
            ]
        }, 
        {
            "key": "user",
            "type": "mysql.user",
            "name": "ghost",
            "password": "xxx",
            "privileges": 'ghost_colabo_en.*:ALL',
            "hosts": [
                "blogs"
            ]
        }
```

## Postgres

```json
    {
        "key": "mediator_1",
        "type": "postgres",
        "database": {
            "name": "ac_mediator"
        },
        "user": {
            "name": "postgres",
            "password": "postgres",
            "privileges": ['ghost_colabo_en.*:ALL']
        },
        "hosts": [
            "mediators"
        ]
    }
```

## MongoDB

TBD. Not implemented yet