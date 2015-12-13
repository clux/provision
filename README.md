# dotclux
[![build status](https://secure.travis-ci.org/clux/dotclux.svg)](http://travis-ci.org/clux/dotclux)

Personal Linux reinstall scripts, for debian based systems.

## Usage
Fetch latest version of this repo and deploy to a fresh installation:

```sh
wget -qO- https://github.com/clux/dotclux/archive/master.tar.gz | tar xz
sudo ./dotclux-master/desktop.sh
```

Alternatively, you can download the docker image that travis is building:

```sh
docker pull clux/dev
docker run -it clux/dev /bin/bash
```

This has everything my desktop has except the secrets and a local checkout of all active git repositories.

## Manual Steps
An hour into `desktop.sh` you need to paste `ssh` keys into chrome (installed first thing) at github and bitbucket sites.
