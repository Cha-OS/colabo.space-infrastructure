# Info

This playbook creates users at the level of the operating system.

# Run

**NOTE**: We use the `ubuntu` user here, since no other users exist yet.

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=ubuntu' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/users.yml
```

# Examples

This will create an `orchestrator` user and integrate its public key (`ssh_pub_key`) so the user can log in without password. Acctually (I think) loging in with password is even forbidden. Additionally, user preferences are configured so the user can also do `sudo` and `su` without password as well.

```json
        {
            "key": "orchestrator",
            "fullname": "Orchestrator",
            "ssh_pub_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDZVkYAtAv1zlr9e5FOaJnSt7/9T9zm5uwR3eM+btn80c5CWNWIo3iSmc/GLQnbJ8mhkfbmFUfUTJsIhb4GLGttIV6adFRIDiFVCl9zySOZEqEd2IxwYj4S59Obhdr8p03Vs0O6G+gu/ZSqIPAvwoSrjyWsd8Viv6xhBmYBqsfbvFhkj6G6uVJapyZegwl52urKQXKCxtEL2b3zQsb3+ua+6PZcjNE0aejgSiSxaTR0Rae5iByDGQ13d9H1EdVTxOBguXvbJ02wMV71+p5BphCowLN6WihtRmN34mHKm0PKeDVItUwLksYhhgBlVMuIt8/cq4TAMMDiQSPHDrkpvUgl Generated-by-Nova"
        }
```
