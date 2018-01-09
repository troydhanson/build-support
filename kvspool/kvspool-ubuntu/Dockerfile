FROM ubuntu:16.04

RUN apt update --fix-missing
RUN apt install -y make cmake gcc autoconf automake \
        libtool git librdkafka-dev libzmq-dev libnanomsg-dev \
        libpcre3-dev

COPY bundles.tar /tmp
COPY build-inside.sh /tmp
RUN /tmp/build-inside.sh

