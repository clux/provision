#!/usr/bin/env bash
set -xeo pipefail
touch ~/.bashrc
cd $(dirname $0)
./tasks/apt
./tasks/node
source ~/.bashrc # need node in other tasks
[ -z "$TRAVIS" ] && ./tasks/ssh
./tasks/sublime
./tasks/npm
./tasks/pip
export gh=$([ -z "$TRAVIS" ] && echo git@github.com: || echo https://github.com/)
./tasks/clone
[ -z "$TRAVIS" ] && ./tasks/cluxdev
[ -z "$TRAVIS" ] && ./tasks/llvm 3.7.0
[ -z "$TRAVIS" ] && ./tasks/system
./tasks/bashrc
source ~/.bashrc
bats test
echo "All done - 'source ~/.bashrc' or open a new shell"
