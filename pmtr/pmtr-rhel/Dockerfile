FROM centos:7

RUN yum --enablerepo=base clean metadata
RUN yum install -y git make cmake gcc autoconf automake \
        libtool

COPY build-inside.sh /tmp
RUN /tmp/build-inside.sh

