#!/bin/bash

docker build -t fluxcap .

echo "If the build completed successfully you can now pick up the"
echo "build products from ${TOP} which is configured as /opt."
echo
echo "To explore the build container:"
echo "docker run -ti fluxcap /bin/bash"
echo
echo "To tar up and copy out the build products:"
echo "docker run -v /tmp:/mnt fluxcap tar cf /mnt/fluxcap.tar -C /opt ."

