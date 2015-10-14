#!/usr/bin/env bash
set -xeuo pipefail
./tasks/apt
./tasks/node
./tasks/ssh
./tasks/sublime
./tasks/cpy
./tasks/shell
./tasks/npm
./tasks/pip
./tasks/clone
./tasks/llvm 3 7 0
./tasks/cleanup
