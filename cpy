#!/bin/sh

cp .jshintrc ~/

# sublime - erase defaults to get rid of bad snippets
rm -rf ~/.config/sublime-text-2/Packages/HTML/
rm -rf ~/.config/sublime-text-2/Packages/JavaScript/
cp -R sublime-text-2/ ~/.config/

# guake settings
cp -R guake/ ~/.gconf/apps/

# keyboard settings
cp %gconf.xml ~/.gconf/desktop/gnome/peripherals/keyboard/kbd/
