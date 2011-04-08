#!/usr/bin/env bash

## makegmtk2.sh: 

## $Revision$
## Copyright 2011 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset
set -o pipefail
set -o errexit

if [ $# != 0 ]; then
    echo usage: "$0"
    exit 2
fi

cd ~/src/collab/gmtk
make clean
hg pull -u # get the latest changes
configure-home --with-logp=table --enable-silent-rules
CFLAGS=-pipe CXXFLAGS=-pipe make -j 3 DEBUGFLAGS="-ggdb3" OPTFLAGS="-O3 -march=nocona"
CFLAGS=-pipe CXXFLAGS=-pipe make -j 3 DEBUGFLAGS="-ggdb3" OPTFLAGS="-O3 -march=nocona" install
