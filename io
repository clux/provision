#!/usr/bin/env bash

# this is an ssh safe install of io that works with pm2-deploy

abort() {  echo "$@" 1>&2 && exit 1; }

version=$(wget -qO- https://iojs.org/dist/index.tab | sed -n 2p | cut -f1)
test -n "$version" || abort missing https://iojs.org/dist/index.tab

echo installing $version

mkdir -p ~/local/iojs-$version
cd ~/local/iojs-$version
wget -qO- https://iojs.org/dist/$version/iojs-$version-linux-x64.tar.gz | tar xz --strip-components=1

# Prepend to PATH in .bashrc (BEFORE INTERACTIVE CUTOUT) to make it work in ssh commands
echo "PATH=\$HOME/local/iojs-$version/bin:\$PATH" | cat - ~/.bashrc > ~/tmpbashrc
mv ~/tmpbashrc ~/.bashrc
