#!/bin/sh

# io install script
# usage ./io 1.6.3

cd ~/Downloads
mkdir io-v$1
cd io-v$1
curl https://iojs.org/dist/v$1/iojs-v$1.tar.gz | tar xz --strip-components=1
./configure --prefix=$HOME/local/io
make
make install
