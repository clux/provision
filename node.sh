#!/bin/sh

# node install script
# usage ./node 0.8.2

cd ~/Downloads
mkdir node-v$1
cd node-v$1
curl http://nodejs.org/dist/v$1/node-v$1.tar.gz | tar xz --strip-components=1
./configure
make
sudo make install

sudo chown -R clux /usr/local/lib/node_modules/
