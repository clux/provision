#!/usr/bin/env bash
set -xeuo pipefail
touch ~/.bashrc
cd $(dirname $0)
./tasks/apt
./tasks/node
source ~/.bashrc # need node in other tasks
[ -z "$TRAVIS" ] && ./tasks/ssh
./tasks/sublime
./tasks/cpy
./tasks/npm
./tasks/pip
./tasks/clone
[ -z "$TRAVIS" ] && ./tasks/llvm 3.7.0
[ -z "$TRAVIS" ] && ./tasks/system
./tasks/bashrc
source ~/.bashrc
bats test
echo "All done - 'source ~/.bashrc' or open a new shell"
