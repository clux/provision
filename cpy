#!/bin/sh

cp .jshintrc ~/repos

# sublime - erase defaults to get rid of bad snippets
rm -rf ~/.config/sublime-text-2/Packages/HTML/
rm -rf ~/.config/sublime-text-2/Packages/JavaScript/
cp -R sublime-text-2/ ~/.config/


# keyboard layouts + shortcut keys
cp %gconf.xml ~/.gconf/desktop/gnome/peripherals/keyboard/kbd/

# redshift
cp redshift.conf  ~/.config/
