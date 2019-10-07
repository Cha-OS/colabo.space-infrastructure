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
            "ssh_pub_key": "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTIJQoJvPt69Mu7TAVSwUqTZqkafu4+3cVcZnJiyeclZiuK3LZNmPHsqM8DhpERSYkMvi3UAQ8FqnCj4+OnBNhyQnc6BXlogmiFHTJ6Az+GraXaSPABxnUYummnMsAWCnHavp7+mQ76dXcj3N/tpJMuAHykTVFp1RvMjoIJQKHj4+u34PJx0mVDYnCmXEJi4Z+GNYyv7CISua1HLTJWgoMMgboHWnj4RMREVNxoyiQNnvdANxl3yQLvKkcdMtlbduuETVxH/otDqHTqgXqrlswIj3dm4Xmdf+/iWTDL1StbFt3HC3GztIRAEtDOdb1HSls8M2B3iWh62Tio16+MzM9 Generated-by-Nova"
        }
```
