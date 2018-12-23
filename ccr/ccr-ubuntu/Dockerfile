FROM ubuntu:16.04

RUN apt-get update && apt-get install -y \
        make cmake gcc autoconf automake \
        libtool git librdkafka-dev

COPY bundles.tar /tmp
COPY build-inside.sh /tmp
RUN /tmp/build-inside.sh

