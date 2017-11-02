FROM ubuntu:16.04

RUN apt update
RUN apt install -y make cmake gcc autoconf automake \
        libtool git librdkafka-dev

COPY build-inside.sh /tmp
RUN /tmp/build-inside.sh

