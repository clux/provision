FROM debian:jessie

RUN apt-get update && apt-get install -y \
    locales \
    ca-certificates \
    ssh

RUN dpkg-reconfigure locales && \
    locale-gen C.UTF-8 && \
    /usr/sbin/update-locale LANG=C.UTF-8

ENV LC_ALL C.UTF-8

RUN wget -qO- https://github.com/clux/dotclux/archive/master.tar.gz | tar xz
RUN TRAVIS=1 ./dotclux-master/desktop.sh

