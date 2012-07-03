#!/bin/sh

# pretty log from http://coderwall.com/p/euwpig?i=3&p=1&t=git
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# pretty diff
git config --global alias.dif "diff --color"

# hg st equivalent
git config --global alias.st "status -s"

# short commit alias
git config --global alias.ci "commit"
git config --global alias.cia "commit -am"
