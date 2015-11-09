FROM debian:jessie
RUN apt-get update && apt-get install -y wget man-db
ENV TRAVIS 1
ADD . /dotclux-master
RUN ./dotclux-master/desktop.sh
RUN bats test
