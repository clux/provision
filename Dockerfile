FROM debian:jessie

RUN wget -qO- https://github.com/clux/dotclux/archive/master.tar.gz | tar xz
RUN TRAVIS=1 ./dotclux-master/desktop.sh
