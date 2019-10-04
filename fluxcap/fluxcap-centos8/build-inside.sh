# This script runs inside a build container.
# The build dependencies are cloned into it,
# the build is conducted and the resulting
# products are installed under ${TOP}.

SHR_REV=8dd76463863623d923b3fa23510dd22a146f0d11
FLUXCAP_REV=98954a6a53eacdd81c1b0d68295e79847b8670b1
LIBUT_REV=e293a1a388340bc5a1c0c542f8ec5d1c8ed85fd7
UTHASH_REV=5e8de9e8c9c0b98fe110708fe7a53b2df3a05210

BUILD=/tmp/build.$$
SRC=/tmp/src.$$
SHR=${SRC}/shr
FLUXCAP=${SRC}/fluxcap
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
git clone -q -b master ${BUNDLES}/fluxcap.bundle ${FLUXCAP}
git clone -q -b master ${BUNDLES}/libut.bundle ${FLUXCAP}/lib/libut
git clone -q -b master ${BUNDLES}/uthash.bundle ${FLUXCAP}/lib/libut/uthash

########################################
# clone sources
########################################
#git clone -q --recursive https://github.com/troydhanson/shr.git ${SHR}
#git clone -q --recursive https://github.com/troydhanson/fluxcap.git ${FLUXCAP}

########################################
# check out pinned revisions
########################################
(cd ${SHR}; git checkout -q ${SHR_REV})
(cd ${FLUXCAP}; git checkout -q ${FLUXCAP_REV})
(cd ${FLUXCAP}/lib/libut; git checkout -q ${LIBUT_REV})
(cd ${FLUXCAP}/lib/libut/uthash; git checkout -q ${UTHASH_REV})

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


