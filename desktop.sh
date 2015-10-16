#!/usr/bin/env bash
set -xeuo pipefail
touch ~/.bashrc
cd $(dirname $0)
./tasks/apt
./tasks/node
source ~/.bashrc # need node
[ -z "$TRAVIS" ] && ./tasks/ssh
./tasks/sublime
./tasks/cpy
./tasks/shell
source ~/.bashrc # need local shell stuff for npm PATH (maybe put that in node task)
./tasks/npm
./tasks/pip
./tasks/clone
[ -z "$TRAVIS" ] && ./tasks/llvm 3.7.0
./tasks/cleanup
[ -z "$TRAVIS" ] && ./tasks/system
source ~/.bashrc
bats test/*.test.bats
echo "All done - 'source ~/.bashrc' or open a new shell"
