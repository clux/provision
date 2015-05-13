#!/usr/bin/env bash

# this is an ssh safe install of io that works with pm2-deploy

abort() {  echo "$@" 1>&2 && exit 1; }

version=$(wget -qO- https://iojs.org/dist/index.tab | sed -n 2p | cut -f1)
test -n "$version" || abort missing https://iojs.org/dist/index.tab

echo installing $version

mkdir -p ~/local/iojs-$version
cd ~/local/iojs-$version
wget -qO- https://iojs.org/dist/$version/iojs-$version-linux-x64.tar.gz | tar xz --strip-components=1

# PATH modification won't work over ssh easily => symlink from ~/bin
# Assumes having run `sudo chown $USER /usr/local`
cd /usr/local/bin
ln -fs ~/local/iojs-$version/bin/npm
ln -fs ~/local/iojs-$version/bin/node
ln -fs ~/local/iojs-$version/bin/iojs
