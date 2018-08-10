FROM ubuntu:16.04

RUN apt update --fix-missing
RUN apt install -y make gcc autoconf automake \
        libtool git 
RUN apt install -y libncurses5-dev
RUN apt install -y libpcre3-dev zlib1g-dev

COPY bundles.tar /tmp
COPY build-inside.sh /tmp
RUN /tmp/build-inside.sh

