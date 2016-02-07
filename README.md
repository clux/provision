# dotclux
[![build status](https://secure.travis-ci.org/clux/dotclux.svg)](http://travis-ci.org/clux/dotclux)

Personal Linux reinstall scripts. Tested with docker for Debian, runs fine on Arch, and has sketchy Gentoo support.

## Usage
Fetch latest version of this repo and deploy to a fresh installation:

```sh
wget -qO- https://github.com/clux/dotclux/archive/master.tar.gz | tar xz
sudo ./dotclux-master/debian8.sh # for a debian netinst (see dockerfile)
sudo ./dotclux-master/arch.sh # for an arch installation started following archboot.sh
```

## Manual Steps
During the `ssh` step (about an hour in on debian, or 10min in on Arch), you need to paste `ssh` keys into chrome (installed first thing) at github and bitbucket sites.

### Personalization
You will not be able to accomplish the [secrets](https://github.com/clux/dotclux/blob/master/tasks/secrets) part of the installation without modification or authorization.

If for some reason you want to try this, and you are not me, you should be able to carry out the procedure by ignoring this script, as well as changing email addresses in the generated public keys in [ssh](https://github.com/clux/dotclux/blob/master/tasks/secrets).

### Dotfiles
See [clux/dotfiles](https://github.com/clux/dotfiles). These are relied on by the npm task for `~/.templates`, `$PATH` extensions, and git aliases for the secrets.

## OS Specific

### Debian
Scripts work well there, although they take a while due to clang not really being well updated on Jessie. Fire it up, come back an hour later to finish up small things.

### Arch
Scripts work well, fast due to not needing to compile anything, but needs some babysitting early on.

### Gentoo
The latter stages work well, provided you manage to `emerge` the world file, which depending on your setup, can take you half a day.
