FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
  locales \
  curl \
  python-pip \
  man-db \
  ca-certificates \
  apt-utils \
  xz-utils

RUN dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
  /usr/sbin/update-locale LANG=C.UTF-8 && \
  echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen && \
  echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
  locale-gen

ENV LC_ALL en_GB.UTF-8
