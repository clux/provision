#!/usr/bin/env bash
set -xeuo pipefail
./tasks/apt
./tasks/node
./tasks/ssh
./tasks/sublime
./tasks/cpy
./tasks/shell
./tasks/npmdeps
./tasks/pipdeps
./tasks/repos
./tasks/llvm 3 7 0
./tasks/cleanup
