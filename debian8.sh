#!/usr/bin/env bash
set -xeo pipefail
cd "$(dirname "$0")"
sudo chown -R "$USER" /usr/local
./tasks/apt
./tasks/llvm 3.7.0
./tasks/profanity
./tasks/sublime
./tasks/node
./tasks/ssh
export GH="git@github.com:"
./tasks/dotfiles # need to set up paths early
source ~/.bashrc
./tasks/clone
#./tasks/cargo # need to have rust first
./tasks/npm
./tasks/pip
# stuff we didnt do in docker
./tasks/secrets
./tasks/cluxdev
#./tasks/system
