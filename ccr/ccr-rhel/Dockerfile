FROM centos:7

RUN yum --enablerepo=base clean metadata
RUN yum -y update
RUN yum install -y git make cmake gcc autoconf automake \
        libtool

# enable epel
RUN yum --enablerepo=extras install -y epel-release
RUN yum -y update
RUN yum install -y librdkafka-devel
RUN yum install -y ncurses-devel

COPY bundles.tar /tmp
COPY build-inside.sh /tmp
RUN /tmp/build-inside.sh

