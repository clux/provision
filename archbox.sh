#!/bin/bash
set -xeo pipefail

# Assumes you have a working arch linux installation
# following archbox.sh

cd "$(dirname "$0")"
sudo chown -R "$USER" /usr/local

localectl set-locale LANG=en_US.UTF-8
# may need mintlocale from aur to do system wide stuff - sublime is complaining..

# AUR install chrome
wget https://aur.archlinux.org/cgit/aur.git/snapshot/google-chrome.tar.gz | tar xzvf
cd google-chrome
makepkg -s
sudo pacman -U google-chrome-*.pkg.tar.xz

./tasks/pacman
