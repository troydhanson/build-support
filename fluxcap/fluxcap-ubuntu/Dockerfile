FROM ubuntu:16.04

RUN apt update
RUN apt install -y make gcc autoconf automake \
        libtool git 

COPY build-inside.sh /tmp
RUN /tmp/build-inside.sh

