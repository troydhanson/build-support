# This script runs inside a build container.
# The build dependencies are cloned into it,
# the build is conducted and the resulting
# products are installed under ${TOP}.

SHR_REV=ee7347347589248a0ecd2fea852070e9c97a8d05
JANSSON_REV=b23201bb1a566d7e4ea84b76b3dcf2efcc025dac
KVSPOOL_REV=a57a6952665415bc752e3146bb5f539b576399f9

BUILD=/tmp/build.$$
SRC=/tmp/src.$$
SHR=${SRC}/shr
KVSPOOL=${SRC}/kvspool
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
git clone -b master ${BUNDLES}/shr.bundle ${SHR}
git clone -b master ${BUNDLES}/jansson.bundle ${JANSSON}
git clone -b master ${BUNDLES}/kvspool.bundle ${KVSPOOL}

########################################
# check out pinned revisions
########################################
(cd ${SHR}; git checkout ${SHR_REV})
(cd ${JANSSON}; git checkout ${JANSSON_REV})
(cd ${JANSSON}; git checkout ${KVSPOOL_REV})

########################################
# conduct builds outside of source trees
########################################
mkdir -p ${BUILD} ${BUILD}/shr ${BUILD}/jansson \
  ${BUILD}/kvspool 

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
# kvspool
########################################
cd ${BUILD}/kvspool
autoreconf -ivf ${KVSPOOL}
${KVSPOOL}/configure --prefix=${TOP} \
  CPPFLAGS="-I${TOP}/include"    \
  LDFLAGS="-L${TOP}/lib -L${TOP}/lib64"
make && make install


