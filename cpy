#!/bin/sh

cp .jshintrc ~/repos

# sublime - erase defaults to get rid of bad snippets
#rm -rf ~/.config/sublime-text-2/Packages/HTML/
#rm -rf ~/.config/sublime-text-2/Packages/JavaScript/
#rm -rf ~/.config/sublime-text-2/Packages/JSHint/
#cp -R sublime-text-2/ ~/.config/


# keyboard layouts + shortcut keys (broken atm.. TODO: fix)
# cp %gconf.xml ~/.gconf/desktop/gnome/peripherals/keyboard/kbd/

# redshift
cp redshift.conf  ~/.config/


# bot configs
cp .curvebot.json ~/repos/
cp .clvr.json ~/repos/
cp .wa.json ~/repos/
