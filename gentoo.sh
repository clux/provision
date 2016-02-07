#!/bin/bash
set -xeo pipefail

echo "This is an experimental sketch"
exit 1
# not quite sure where to pick up from

cd "$(dirname "$0")"
sudo chown -R "$USER" /usr/local

# update world file, and maybe more
./tasks/emerge
emerge -uDN world -t # enjoy your day
# TODO: portage config and explicit unmasks

# rest follows my standard template
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
