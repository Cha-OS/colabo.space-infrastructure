# Ubuntu 20+

+ for the Ubuntu 20+ for pip and pip3 are not available anymore by default
+ https://askubuntu.com/questions/1061486/unable-to-locate-package-python-pip-when-trying-to-install-from-fresh-18-04-in
+ https://askubuntu.com/questions/378558/unable-to-locate-package-while-trying-to-install-packages-with-apt/481355#481355
+ https://superuser.com/questions/1545380/ubuntu-20-04-e-unable-to-locate-package-python-pip

We need to extend apt-playbook to support adding repositories, which also makes problems with native repo names, but we handled it:
+ https://github.com/ansible/ansible/issues/21766
+ https://github.com/ansible/ansible/issues/48714

But, also, pip (2) has been removed, and only pip3 is supported
+ https://bugs.launchpad.net/ubuntu/+source/python-pip/+bug/1870878
+ https://github.com/pypa/pip/issues/7620

Similar(?)
+ https://askubuntu.com/questions/1037208/unmet-dependencies-while-trying-to-install-python3-pip-in-ubuntu-18-04