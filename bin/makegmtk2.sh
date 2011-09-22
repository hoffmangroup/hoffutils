#!/usr/bin/env bash

## makegmtk2.sh: make new GMTK

## $Revision$
## Copyright 2011 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset
set -o pipefail
set -o errexit

if [ $# != 0 ]; then
    echo usage: "$0"
    exit 2
fi

NEW="${NEW:-}"

OPTFLAGS="${OPTFLAGS:--O3 -march=nocona}"
DEBUGFLAGS="${DEBUGFLAGS:--ggdb3}"
CFLAGS=-pipe
CXXFLAGS="$CFLAGS"
MAKEFLAGS=(-j 3 "CFLAGS=$CFLAGS" "CXXFLAGS=$CXXFLAGS" "OPTFLAGS=$OPTFLAGS"
    "DEBUGFLAGS=$DEBUGFLAGS")

# test suite location
export TEST_AND_DEV="$HOME/src/collab/test_and_dev"

cd ~/src/collab/gmtk

if [ "$NEW" ]; then
    make $MAKEFLAGS clean || true
    hg pull -u # get the latest changes
    svn up "$TEST_AND_DEV"
    autoreconf -i
fi

configure-home --with-logp=table --with-LZERO=-1.0E20
make "${MAKEFLAGS[@]}"
make "${MAKEFLAGS[@]}" check
make "${MAKEFLAGS[@]}" install
