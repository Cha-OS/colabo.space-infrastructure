# Info

This playbook builds python parts of the projects. It works both for python 2 and python 3. It builds virtual environments (`vurtualenv`), packages (`pip`), or requirements (`requirements.txt`).

## TODO

+ Fix that virtual-env group (recursively) is `developer` not `orchestrator`. Do it by adding file for each entry with: `_virtualenv` parameter.

```yml
  - name: Set folders
    # https://docs.ansible.com/ansible/latest/modules/file_module.html
    with_items: "{{ items_array }}"
    when: "{{ item.hosts is not defined or ((active_hosts_groups | intersect(item.hosts)) | length>0) }}" # check hosts matching
    file:
      path: '{{item.key}}'
      state: '{{item.state}}'
      owner: '{{item.owner}}'
      group: '{{item.group}}'
      mode: '{{item.mode}}'
      recurse: yes
```

# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/python.yml
```

# Examples

```json
        // install `virtualenv` module for python2
        {
            "key": "virtualenv-2",
            "type": "pip2",
            "package": "virtualenv",
            "executable": "pip"
        }, 
        // install `virtualenv` module for python3
        {
            "key": "virtualenv-3",
            "type": "pip3",
            "package": "virtualenv",
            "executable": "pip3"
        },
        // install `pymongo` module for both python2 and python3
        // into virtualenv `/var/services/colabo-env-python2` and
        // `/var/services/colabo-env-python3` respectivelly
        {
            "key": "pymongo",
            "package": "pymongo",
            "type": "pip23",
            "_virtualenv": "/var/services/colabo-env-python"
        },
        // install requirements from external requirements for python2
        // into virtualenv `/var/services/colabo-env-python2`
        {
            "key": "requirements-similarity",
            "type": "requirements2",
            "_virtualenv": "/var/services/colabo-env-python",
            "requirements": "../variables/requirements-similarity.txt"
        },
        // install requirements from external requirements for both python2 and python3
        // into virtualenv `/var/services/colabo-env-python2` and
        // `/var/services/colabo-env-python3` respectivelly
        {
            "key": "requirements-colaboflow",
            "type": "requirements23",
            "_virtualenv": "/var/services/colabo-env-python",
            "requirements": "../variables/requirements-colaboflow.txt",
            "hosts": [
                "litterra"
            ]
        }
```
