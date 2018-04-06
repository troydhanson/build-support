#!/bin/bash

PMTR=https://github.com/troydhanson/pmtr/archive/master.tar.gz

curl -sSL -o pmtr.tar.gz $PMTR
docker build -t pmtr-alpine .
