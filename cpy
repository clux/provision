#!/bin/sh

cp .jshintrc ~/repos
cp pep8 ~/.config
cp redshift.conf  ~/.config/

# sublime 3
rm -rf ~/.config/sublime-text-3/Cache/JavaScript/
cp -R sublime-text-3/ ~/.config/

# autostart + gconf settings
cp -R gconf/* ~/.gconf/
cp  autostart/* ~/.config/autostart

# TODO: maybe look at keyboard layouts + shortcut keys

# user picture
cp iface ~/.iface
