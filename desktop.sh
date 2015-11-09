#!/usr/bin/env bash
set -xeo pipefail
touch ~/.bashrc
cd $(dirname $0)
./tasks/apt
./tasks/node
source ~/.bashrc # need node in other tasks
[ -z "$TRAVIS" ] && ./tasks/ssh
./tasks/sublime
export gh=$([ -z "$TRAVIS" ] && echo git@github.com: || echo https://github.com/)
./tasks/dotfiles # need to set up paths early
./tasks/clone
if [ -z "$TRAVIS" ]; then
  ./tasks/npm
  ./tasks/pip
  ./tasks/cluxdev
  ./tasks/llvm 3.7.0
  #./tasks/system
fi
