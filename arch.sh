#!/bin/bash
set -xeo pipefail

# Assumes you have a working arch linux installation
# following archbox.sh

cd "$(dirname "$0")"
sudo chown -R "$USER" /usr/local

# Need a chromey version with flash player still...
wget -qO- https://aur.archlinux.org/cgit/aur.git/snapshot/google-chrome.tar.gz | tar xzv
cd google-chrome
makepkg -s
pacman -U google-chrome-*.pkg.tar.xz

./tasks/pacman
./tasks/sublime
./tasks/node
./tasks/ssh
export GH="git@github.com:"
./tasks/dotfiles # need to set up paths early
source ~/.bashrc
./tasks/clone
./tasks/cargo
./tasks/npm
./tasks/pip
./tasks/secrets
./tasks/cluxdev
