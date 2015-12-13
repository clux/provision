FROM debian:jessie

# Stuff needed to get as close as possible to a plain debian netinst
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get install -y \
  locales \
  wget \
  man-db \
  nano \
  ca-certificates

RUN dpkg-reconfigure locales && \
  locale-gen C.UTF-8 && \
  /usr/sbin/update-locale LANG=C.UTF-8 && \
  echo 'en_GB.UTF-8 UTF-8' >> /etc/locale.gen && \
  locale-gen

ENV LC_ALL en_GB.UTF-8
ENV TRAVIS 1

# Step by step execution - only invalidating cache when each task changes
ADD tasks/apt tasks/
RUN ./tasks/apt

ADD tasks/llvm tasks/
RUN ./tasks/llvm 3.7.0

ADD tasks/profanity tasks/
RUN ./tasks/profanity
