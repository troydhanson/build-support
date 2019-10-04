#!/bin/bash

tar cf bundles.tar -C ../.. bundles
docker build -t fluxcap-centos7 .

echo "If the build completed successfully you can now pick up the"
echo "build products from \${TOP} which is configured as /opt."
echo
echo "To explore the build container:"
echo "docker run -ti fluxcap-centos7 /bin/bash"
echo
echo "To tar up and copy out the build products:"
echo "docker run -v /tmp:/mnt fluxcap-centos7 tar cf /mnt/fluxcap-centos7.tar -C /opt ."

