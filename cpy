#!/bin/sh

cp .jshintrc ~/

# sublime - erase defaults to get rid of bad snippets
rm -rf ~/.config/sublime-text-2/Packages/HTML/
rm -rf ~/.config/sublime-text-2/Packages/JavaScript/
cp -R sublime-text-2/ ~/.config/
