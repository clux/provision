# dotclux
[![build status](https://secure.travis-ci.org/clux/dotclux.svg)](http://travis-ci.org/clux/dotclux)

Personal Arch Linux provisioning scripts in ansible.

## Usage
Download and use on second boot (when successfully booted into a configured chroot as root).
For a detailed guide follow [archboot.sh](./archboot.sh).

```sh
curl https://api.github.com/repos/clux/dotclux/tarball/ansible | tar xz
# in created dir:
./DEPLOY bootstrap kjttks.yml
# change password of desktop_user, then boot (to blacklist nouveau) to an X desktop
./DEPLOY core kjttks.yml
```

To provision specific roles/tags later:

```sh
./DEPLOY kjttks.yml gem,npm
```
