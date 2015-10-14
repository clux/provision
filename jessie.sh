#!/usr/bin/env bash
set -xeuo pipefail
./linux
./node
./git
./editor
./cpy
./shell
./npmdeps
./pipdeps
./repos
./cleanup
