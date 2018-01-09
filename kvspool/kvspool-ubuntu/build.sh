#!/bin/bash

tar cf bundles.tar -C ../.. bundles
docker build -t kvspool .

echo "If the build completed successfully you can now pick up the"
echo "build products from \${TOP} which is configured as /opt."
echo
echo "To explore the build container:"
echo "docker run -ti kvspool /bin/bash"
echo
echo "To tar up and copy out the build products:"
echo "docker run -v /tmp:/mnt kvspool tar cf /mnt/kvspool.tar -C /opt ."

