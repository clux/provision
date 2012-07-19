#!/bin/sh

# set name and email
git config --global user.name "clux"
git config --global user.email "analsandblaster@gmail.com"

# pretty log from http://coderwall.com/p/euwpig?i=3&p=1&t=git
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# pretty diff
git config --global alias.dif "diff --color"

# hg st equivalent
git config --global alias.st "status -s"

# short commit alias
git config --global alias.ci "commit"
git config --global alias.cia "commit -am"

# generate ssh keys
ssh-keygen -t rsa -C "analsandblaster@gmail.com"
echo "LOG IN TO GITHUB AND PASTE THE FOLLOWING YOUR SSH KEYS SECTION:"
cat ~/.ssh/id_rsa.pub
