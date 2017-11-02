#!/bin/bash

docker build -t pmtr-rhel .

echo "If the build completed successfully you can now pick up the"
echo "build products from ${TOP} which is configured as /opt."
echo
echo "To explore the build container:"
echo "docker run -ti pmtr-rhel /bin/bash"
echo
echo "To tar up and copy out the build products:"
echo "docker run -v /tmp:/mnt pmtr-rhel tar cf /mnt/pmtr-rhel.tar -C /opt ."

