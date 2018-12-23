# This script runs inside a build container.
# The build dependencies are cloned into it,
# the build is conducted and the resulting
# products are installed under ${TOP}.

SHR_REV=8dd76463863623d923b3fa23510dd22a146f0d11
CCR_REV=a9c045471130b781e1c8b8e16ba0fee8fcaa71c5
JANSSON_REV=b23201bb1a566d7e4ea84b76b3dcf2efcc025dac
LIBUT_REV=e293a1a388340bc5a1c0c542f8ec5d1c8ed85fd7
UTHASH_REV=5e8de9e8c9c0b98fe110708fe7a53b2df3a05210

BUILD=/tmp/build.$$
SRC=/tmp/src.$$
SHR=${SRC}/shr
CCR=${SRC}/ccr
JANSSON=${SRC}/jansson
TOP=/opt # install root
BUNDLES=/tmp/bundles

########################################
# clone sources
#
# this version clones from a saved bundle
#
# to make a bundle from the head of an 
# existing cloned repo you can use 
# bundle create /tmp/<name>.bundle @
# However, note that its submodules and
# and of their recursive submodules need
# to be bundled and cloned into place too.
########################################
tar xf /tmp/bundles.tar -C /tmp
git clone -q -b master ${BUNDLES}/shr.bundle ${SHR}
git clone -q -b master ${BUNDLES}/ccr.bundle ${CCR}
git clone -q -b master ${BUNDLES}/libut.bundle ${CCR}/lib/libut
git clone -q -b master ${BUNDLES}/uthash.bundle ${CCR}/lib/libut/uthash
git clone -q -b master ${BUNDLES}/jansson.bundle ${JANSSON}

########################################
# clone sources
########################################
#git clone -q --recursive https://github.com/troydhanson/shr.git ${SHR}
#git clone -q --recursive https://github.com/troydhanson/ccr.git ${CCR}
#git clone -q https://github.com/akheron/jansson.git ${JANSSON}

########################################
# check out pinned revisions
########################################
(cd ${SHR}; git checkout -q ${SHR_REV})
(cd ${CCR}; git checkout -q ${CCR_REV})
(cd ${CCR}/lib/libut; git checkout -q ${LIBUT_REV})
(cd ${CCR}/lib/libut/uthash; git checkout -q ${UTHASH_REV})
(cd ${JANSSON}; git checkout -q ${JANSSON_REV})

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
  CPPFLAGS="-I${CCR}/cc -I${CCR}/ccr/src -I${TOP}/include"    \
  LDFLAGS="-L${TOP}/lib -L${TOP}/lib64 -L${BUILD}/ccr/ccr/src"
make && make install


