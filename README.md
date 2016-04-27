# dotclux
[![build status](https://secure.travis-ci.org/clux/dotclux.svg)](http://travis-ci.org/clux/dotclux)

Personal Linux re-install logic in ansible for Debian, Arch, and Gentoo.

## Usage
Ansible version is only tested locally on the branch.

```sh
wget -qO- https://github.com/clux/dotclux/archive/ansible.tar.gz | tar xz
cd dotclux-master
sudo pacman -S python-virtualenv
source dev.sh
```

Then do either a full deploy:

```sh
ansible-playbook -i hosts -vv --ask-become-pass machine.yml
```

or run individiual roles (which sometimes works without privilege escalation):

```sh
ansible-playbook -i hosts -vv --tags="gem,npm" machine.yml
```

Tags set to `packages` would do a system upgrade.
