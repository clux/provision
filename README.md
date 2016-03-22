# dotclux
[![build status](https://secure.travis-ci.org/clux/dotclux.svg)](http://travis-ci.org/clux/dotclux)

Personal Linux re-install logic in ansible for Debian, Arch, and Gentoo.

## Usage
Ansible version is only tested locally on the branch.

```sh
wget -qO- https://github.com/clux/dotclux/archive/master.tar.gz | tar xz
cd dotclux-master
virtualenv -p $(which python2) venv
pip install -r requirements.txt
ansible-playbook -i hosts site.yml
```
