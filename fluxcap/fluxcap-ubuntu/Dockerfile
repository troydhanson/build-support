FROM ubuntu:18.04

RUN apt-get update && apt-get install -y    \
    make gcc autoconf automake libtool git  \
    libpcre3-dev zlib1g-dev

COPY bundles.tar /tmp
COPY build-inside.sh /tmp
RUN /tmp/build-inside.sh

