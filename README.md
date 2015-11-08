# dotclux
[![build status](https://secure.travis-ci.org/clux/dotclux.svg)](http://travis-ci.org/clux/dotclux)

Personal Linux reinstall scripts and configs. Only tested on Debian 8 lately, but should work on most debian based systems.

## Usage
Fetch latest version of this repo and deploy:

```sh
wget -qO- https://github.com/clux/dotclux/archive/master.tar.gz | tar xz
sudo ./dotclux-master/desktop.sh
```

## SSH Bootstrap
Note that the script will stop after generating ssh keys to ensure you can add them to github/bitbucket. Thus, you should probably login to chrome, github, bitbucket after chrome is installed (one of the first steps).
