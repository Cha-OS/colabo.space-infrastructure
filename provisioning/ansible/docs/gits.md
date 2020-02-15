# Info

This playbook clones git repos to the remote hosts and sets the folders and files privileges

# Run

```sh
ansible-playbook -i variables/hosts.yaml -e 'ansible_ssh_user=orchestrator' --private-key ~/.ssh/orchestration-iaas-no.pem --extra-vars '{"active_hosts_groups": ["litterra"]}' playbooks/gits.yml
```

# Examples

```json
    // clone `repo` into `dest` directory
    {
        "key": "colabo",
        "repo": "https://github.com/Cha-OS/colabo/",
        "dest": "/var/repos/colabo",
        "depth": 1,
        "force": true,
        "recursive": true,
        "owner": "www-data",
        "group": "developers",
        "mode": "ug=rwX,o=rX,g+s"
    }
```

## Private repo

+ You need to provide path to the private key `key_file_pem` and public key `key_file_pub`
    + to generate: `ssh-keygen`
        + provide absolute path, as relative is making problems?!
+ The `repo` path should be within SSH format, rather than HTTPS
+ Before starting the playbook, you need to login remotely as the user which runs playbook on the romote machine and accept github host: `ssh -T git@github.com`
  + TBD: This can be avoided by extending the playbook

### Github

https://github.com/settings/keys


```json
{
    "key": "litterra",
    "repo_https": "https://github.com/mprinc/LitTerra/",
    "repo": "git@github.com:mprinc/LitTerra.git",
    "key_file_pem": "~/.ssh/chaos.ngo.readonly.pem",
    "key_file_pub": "~/.ssh/chaos.ngo.readonly.pub",
    "dest": "/var/repos/litterra",
    "depth": 1,
    "force": true,
    "recursive": true,
    "owner": "www-data",
    "group": "developers",
    "mode": "ug=rwX,o=rX,g+s"
}
```

Bitbucket:
```json
{
        "key": "ml-share",
        "repo_https": "https://bitbucket.org/mPrinC/ml-laza/",
        "repo": "git@bitbucket.org:mprinc/ml-laza.git",
        "key_file_pem": "~/.ssh/bitbucket-sasha.pem",
        "key_file_pub": "~/.ssh/bitbucket-sasha.pub",
        "dest": "/var/repos/ml-laza",
        "depth": 1,
        "force": true,
        "recursive": true,
        "owner": "www-data",
        "group": "developers",
        "mode": "ug=rwX,o=rX,g+s",
        "hosts": [
            "instances"
        ]
    }
```

+ https://docs.ansible.com/ansible/latest/modules/git_module.html
  + [Cloning private GitHub repositories with Ansible on a remote server through SSH](https://www.jeffgeerling.com/blog/2018/cloning-private-github-repositories-ansible-on-remote-server-through-ssh)
    + solution with both 1) copying keys and 2) without copying keys (safer)
+ [Ansible task - clone private git without SSH forwarding](https://stackoverflow.com/questions/44970728/ansible-task-clone-private-git-without-ssh-forwarding)
+ [Example playbook for cloning a private git repository with Ansible.](https://gist.github.com/devynspencer/effa29af449c46477ac71213210e7043)
+ [Use Ansible to clone & update private git repositories via ssh](https://manueldewald.de/2018/07/use-ansible-to-clone-update-private-git-repositories-via-ssh.html)
+ https://stackoverflow.com/questions/44970728/ansible-task-clone-private-git-without-ssh-forwarding
+ https://www.reddit.com/r/devops/comments/6e7pnt/i_made_an_ansible_role_for_cloning_private_repos/
  + https://github.com/adamyala/ansible-role-clone-repo
  + https://github.com/adamyala/ansible-role-clone-repo/blob/master/tasks/main.yml

+ Accessing repo with SSH key
    + [How to access a git repository using SSH?](https://askubuntu.com/questions/527551/how-to-access-a-git-repository-using-ssh)
    + [Add SSH Key to Bitbucket / Github in Ubuntu 16.04](https://gist.github.com/arsho/b91add3f536154386b9a4dca9373d5bb)

+ Setting up local account for Git
  + [How do I setup SSH key based authentication for GitHub by using ~/.ssh/config file?](https://askubuntu.com/questions/1097038/how-do-i-setup-ssh-key-based-authentication-for-github-by-using-ssh-config-fi)

+ SSH agent
  + [Mac OS X Lion, Terminal and ssh: how to start ssh-agent at login](https://alchemycs.com/2011/08/mac-os-x-lion-terminal-and-ssh-how-to-start-ssh-agent-at-login/)
  + https://www.reddit.com/r/osx/comments/52zn5r/difficulties_with_sshagent_in_macos_sierra/
  + https://gist.github.com/gravefolk/96b79c321f7e6e52457f8a6fef603eac

+ Readonly account
  + https://github.com/docker/hub-feedback/issues/967
  + https://github.community/t5/How-to-use-Git-and-GitHub/Can-I-give-read-only-access-to-a-private-repo-from-a-developer/m-p/2062#M640
  + create a new user, that will be only for readonly activities
  + create a readonly team (as user cannot have readonly access to a repo, but only a team)
  + Repo must belong to an organization (otherwise you will be able to add only members, and not teams)
+ go to the repo settings
+ add readonly team
+ for a readonly user, create a new key
  + [Generating a new SSH key and adding it to the ssh-agent](https://help.github.com/en/articles/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent)

```sh
ssh-keygen -t rsa -b 4096 -C "your_email@example.com" -N ''
```

+ add it to Github keys
  + GitLab - https://gitlab.com/profile/keys
  + Github - https://github.com/settings/keys

Testing your SSH connection
+ [Testing your SSH connection @ Github](https://help.github.com/en/articles/testing-your-ssh-connection)
  + `ssh -T git@github.com`

### TODO

#### Adding hosts to avoid checking for fingerprint

+ [how to avoid ssh asking permission?](https://unix.stackexchange.com/questions/33271/how-to-avoid-ssh-asking-permission)
+ [Can I automatically add a new host to known_hosts?](https://serverfault.com/questions/132970/can-i-automatically-add-a-new-host-to-known-hosts)
+ NOTE: Be careful about MITMA (attack)

#### Avoid copying keys on the server

+ [Cloning private GitHub repositories with Ansible on a remote server through SSH](https://www.jeffgeerling.com/blog/2018/cloning-private-github-repositories-ansible-on-remote-server-through-ssh)
  + solution with both 1) copying keys and 2) without copying keys (safer)
