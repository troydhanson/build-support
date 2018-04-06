FROM python:3.6-alpine
RUN apk add --update build-base autoconf automake
 
WORKDIR /opt
ADD pmtr.tar.gz /opt
WORKDIR /opt/pmtr-master
RUN ./autogen.sh
RUN ./configure --bindir=/usr/bin --sysconfdir=/etc
RUN make -j ${nproc} && make install
COPY pmtr.conf /etc/pmtr.conf
CMD [ "/usr/bin/pmtr", "-IFc", "/etc/pmtr.conf" ]
