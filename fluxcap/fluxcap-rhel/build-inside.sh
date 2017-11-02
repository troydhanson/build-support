# This script runs inside a build container.
# The build dependencies are cloned into it,
# the build is conducted and the resulting
# products are installed under ${TOP}.

SHR_REV=5a009e01cf7fc47c949a21681f6397e66aba9c3b
FLUXCAP_REV=56d9b2c55bfaa644e865e16a8c30751df5f7a805

BUILD=/tmp/build.$$
SRC=/tmp/src.$$
SHR=${SRC}/shr
FLUXCAP=${SRC}/fluxcap
TOP=/opt # install root

########################################
# clone sources
########################################
git clone --recursive https://github.com/troydhanson/shr.git ${SHR}
git clone --recursive https://github.com/troydhanson/fluxcap.git ${FLUXCAP}

########################################
# check out pinned revisions
########################################
(cd ${SHR}; git checkout ${SHR_REV})
(cd ${FLUXCAP}; git checkout ${FLUXCAP_REV})

########################################
# conduct builds outside of source trees
########################################
mkdir -p ${BUILD} ${BUILD}/shr ${BUILD}/fluxcap

########################################
# shr
########################################
cd ${BUILD}/shr
autoreconf -ivf ${SHR}
${SHR}/configure --prefix=${TOP}
make && make install

########################################
# fluxcap
########################################
cd ${BUILD}/fluxcap
autoreconf -ivf ${FLUXCAP}
${FLUXCAP}/configure --prefix=${TOP} \
  CPPFLAGS="-I${TOP}/include"        \
  LDFLAGS="-L${TOP}/lib -L${TOP}/lib64"
make && make install


