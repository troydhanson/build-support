FROM ubuntu:16.04

RUN apt update --fix-missing
RUN apt install -y make gcc autoconf automake \
        libtool git 

COPY bundles.tar /tmp
COPY build-inside.sh /tmp
RUN /tmp/build-inside.sh

