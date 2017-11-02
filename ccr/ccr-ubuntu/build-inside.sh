# This script runs inside a build container.
# The build dependencies are cloned into it,
# the build is conducted and the resulting
# products are installed under ${TOP}.

SHR_REV=5a009e01cf7fc47c949a21681f6397e66aba9c3b
CCR_REV=e95b3884d5068b60eb2f87088c8af73767de463e
JANSSON_REV=b23201bb1a566d7e4ea84b76b3dcf2efcc025dac

BUILD=/tmp/build.$$
SRC=/tmp/src.$$
SHR=${SRC}/shr
CCR=${SRC}/ccr
JANSSON=${SRC}/jansson
TOP=/opt # install root

########################################
# clone sources
########################################
git clone --recursive https://github.com/troydhanson/shr.git ${SHR}
git clone --recursive https://github.com/troydhanson/ccr.git ${CCR}
git clone https://github.com/akheron/jansson.git ${JANSSON}

########################################
# check out pinned revisions
########################################
(cd ${SHR}; git checkout ${SHR_REV})
(cd ${CCR}; git checkout ${CCR_REV})
(cd ${JANSSON}; git checkout ${JANSSON_REV})

########################################
# conduct builds outside of source trees
########################################
mkdir -p ${BUILD} ${BUILD}/shr ${BUILD}/ccr ${BUILD}/jansson 

########################################
# jansson
########################################
cd ${BUILD}/jansson
autoreconf -ivf ${JANSSON}
${JANSSON}/configure --prefix=${TOP}
make && make install

########################################
# shr
########################################
cd ${BUILD}/shr
autoreconf -ivf ${SHR}
${SHR}/configure --prefix=${TOP}
make && make install

########################################
# ccr
########################################
cd ${BUILD}/ccr
autoreconf -ivf ${CCR}
${CCR}/configure --prefix=${TOP} \
  CPPFLAGS="-I${TOP}/include"    \
  LDFLAGS="-L${TOP}/lib -L${TOP}/lib64"
make && make install


