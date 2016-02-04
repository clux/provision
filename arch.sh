#!/bin/bash
set -xeo pipefail

# Assumes you have a working arch linux installation
# following archbox.sh

cd "$(dirname "$0")"
sudo chown -R "$USER" /usr/local

./tasks/pacman
./tasks/sublime
./tasks/node
./tasks/ssh
export GH="git@github.com:"
./tasks/dotfiles # need to set up paths early
source ~/.bashrc
./tasks/clone
./tasks/npm
./tasks/pip
./tasks/secrets
./tasks/cluxdev
