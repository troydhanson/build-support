# This script runs inside a build container.
# The build dependencies are cloned into it,
# the build is conducted and the resulting
# products are installed under ${TOP}.

PMTR_REV=08ccac705b9da7389db532b39c5d150c4bb00890

BUILD=/tmp/build.$$
SRC=/tmp/src.$$
PMTR=${SRC}/pmtr
TOP=/opt # install root

########################################
# clone sources
########################################
git clone -q https://github.com/troydhanson/pmtr.git ${PMTR}

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


