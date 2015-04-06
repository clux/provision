#!/bin/sh

cp .jshintrc ~/repos

# sublime 3 - ditto
rm -rf ~/.config/sublime-text-3/Cache/JavaScript/
cp -R sublime-text-3/ ~/.config/

# keyboard layouts + shortcut keys (broken atm.. TODO: fix)
# cp %gconf.xml ~/.gconf/desktop/gnome/peripherals/keyboard/kbd/

# user picture
#cp .face ~/

# redshift
cp redshift.conf  ~/.config/

