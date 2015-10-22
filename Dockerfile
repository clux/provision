FROM debian:jessie

RUN apt-get update && apt-get install -y \
    ca-certificates \
    ssh \
    wget

RUN wget -qO- https://github.com/clux/dotclux/archive/master.tar.gz | tar xz
RUN TRAVIS=1 ./dotclux-master/desktop.sh
