# This script runs inside a build container.
# The build dependencies are cloned into it,
# the build is conducted and the resulting
# products are installed under ${TOP}.

PMTR_REV=780c17bad593fefe8bb9a2a948e51be9144f0935

BUILD=/tmp/build.$$
SRC=/tmp/src.$$
PMTR=${SRC}/pmtr
TOP=/opt # install root
BUNDLES=/tmp/bundles

########################################
# clone sources
########################################
tar xf /tmp/bundles.tar -C /tmp
git clone -q -b master ${BUNDLES}/pmtr.bundle ${PMTR}
#git clone -q https://github.com/troydhanson/pmtr.git ${PMTR}

########################################
# check out pinned revisions
########################################
(cd ${PMTR}; git checkout -q ${PMTR_REV})

########################################
# conduct builds outside of source trees
########################################
mkdir -p ${BUILD} ${BUILD}/pmtr 

########################################
# pmtr
# includes the initscripts so the user
# can run them in the deployment system
########################################
cd ${BUILD}/pmtr
autoreconf -ivf ${PMTR}
${PMTR}/configure --bindir=${TOP}/bin \
                  --sysconfdir=/etc   \
make && make install
cp -r ${PMTR}/initscripts ${TOP}/bin


