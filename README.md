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
Stuff to do immediately:

- keyboard layout: add "us int dead", alt-shift change, caps compose
- look and feel of UI: 
  * effects: OFF
  * mouse: pad on, no clicks on pad, two finger basic

Stuff do do while it's going:

- startup apps: clean out what isn't needed (everything else added eventually)

Stuff you need to wait for stuff:

- after `apt`: login to chrome, gmail, and dvcs services
- after `ssh`: paste keys at dvcs account settings pages *SCRIPT HALTED UNTIL YOU DO THIS*
- after `cpy`: [sublime license](https://mail.google.com/mail/u/0/#search/sublime+license/13a942d72a211e81)
- after `cpy`: [sublime package control](https://packagecontrol.io/installation)
