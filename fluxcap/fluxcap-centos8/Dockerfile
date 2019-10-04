FROM centos:8

#RUN yum --enablerepo=base clean metadata
RUN yum install -y git make cmake gcc autoconf automake \
        libtool

# enable epel
#RUN yum --enablerepo=extras install -y epel-release
#RUN yum install -y ncurses-devel

COPY bundles.tar /tmp
COPY build-inside.sh /tmp
RUN /tmp/build-inside.sh

