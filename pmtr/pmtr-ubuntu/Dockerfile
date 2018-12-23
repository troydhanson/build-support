FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
        make gcc autoconf automake \
        libtool git

COPY build-inside.sh /tmp
RUN /tmp/build-inside.sh

