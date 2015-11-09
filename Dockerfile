FROM debian:jessie

# Stuff needed to get as close as possible to a plain debian netinst
RUN apt-get update && apt-get install -y wget man-db

# Copy over just what we need so we dont invalidate the cache with trivial changes
ADD desktop.sh dotclux/
ADD tasks dotclux/tasks

# Do the hard work
ENV TRAVIS 1
RUN ./dotclux/desktop.sh

# Verify
ADD test dotclux/test
RUN bash -c 'source ~/.bashrc && bats dotclux/test'
