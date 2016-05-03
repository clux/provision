FROM debian:jessie

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
  apt-utils \
  aptitude \
  ca-certificates \
  curl \
  libffi-dev \
  libssl-dev \
  libyaml-dev \
  locales \
  man-db \
  python-pip \
  python-dev \
  ssh \
  virtualenv \
  vim \
  xz-utils

RUN dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
  /usr/sbin/update-locale LANG=C.UTF-8 && \
  echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen && \
  echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen && \
  locale-gen

ENV LC_ALL en_GB.UTF-8
