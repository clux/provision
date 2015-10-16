# dotclux
[![build status](https://secure.travis-ci.org/clux/dotclux.svg)](http://travis-ci.org/clux/dotclux)

Personal Linux reinstall scripts and configs. Only tested on Debian 8 lately, but should work on most debian based systems.

## Usage
Fetch latest version of this repo and deploy:

```sh
wget -qO- https://github.com/clux/dotclux/archive/master.tar.gz | tar xz
sudo ./dotclux-master/desktop.sh
```

## Manual tasks
Tasks that can be done after immediately:

- startup apps: clean out what isn't needed (everything else added)
- keyboard layout: add "us int dead", alt-shift change, caps compose
- look and feel of UI: { effects: OFF, mouse: PAD, general: SCALE }

Tasks that can be done post certain tasks:

- `ssh`: login to chrome and dvcs services and paste ssh keys
- `sublime` [license](https://mail.google.com/mail/u/0/#search/sublime+license/13a942d72a211e81)
- `sublime` [package control](https://packagecontrol.io/installation)
