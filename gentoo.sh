#!/bin/bash
set -xeo pipefail

# experimental thing for gentoo
# not quite sure where to pick up from

cd "$(dirname "$0")"
sudo chown -R "$USER" /usr/local

# update world file, and maybe more
./tasks/emerge
emerge -uDN world -t # enjoy your day

./tasks/sublime
./tasks/node
./tasks/ssh
export GH="git@github.com:"
./tasks/dotfiles
source ~/.bashrc
./tasks/clone
./tasks/npm
./tasks/pip
./tasks/secrets
./tasks/cluxdev
