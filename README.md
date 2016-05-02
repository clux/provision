# dotclux
[![build status](https://secure.travis-ci.org/clux/dotclux.svg)](http://travis-ci.org/clux/dotclux)

Personal Linux re-install logic in ansible for Debian and Arch. And and Gentoo stubs.

## Usage
Ansible version is only tested locally on the branch.

```sh
curl -L https://api.github.com/repos/clux/dotclux/tarball/ansible | tar xz --strip-components=1
./DEPLOY bootstrap kjttks.yml
# boot
./DEPLOY core kjttks.yml
```

To provision specific roles/tags:

```sh
./DEPLOY gem,npm kjttks.yml
```
