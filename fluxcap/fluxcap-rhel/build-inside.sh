# This script runs inside a build container.
# The build dependencies are cloned into it,
# the build is conducted and the resulting
# products are installed under ${TOP}.

SHR_REV=a86524ac213d0c41b4a993b44b6af48b0aa49911
FLUXCAP_REV=2abda82af32669f923412bf343ce73c511ef4b74
LIBUT_REV=e293a1a388340bc5a1c0c542f8ec5d1c8ed85fd7
TPL_REV=7adbfa38c97c199056e8455803053bbf8e0470e8
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
git clone -q -b master ${BUNDLES}/tpl.bundle ${FLUXCAP}/lib/tpl
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
(cd ${FLUXCAP}/lib/tpl; git checkout -q ${TPL_REV})
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


