#!/usr/bin/env bash

## makegmtk2.sh: make new GMTK

## $Revision$
## Copyright 2011 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset -o pipefail -o errexit

if [ $# != 0 ]; then
    echo usage: "$0" [DIR]
    exit 2
fi

NEW="${NEW:-}"
DIR="${1:-$HOME/src/collab/gmtk}" # . for current dir

OPTFLAGS="${OPTFLAGS:--O3 -march=native}"
DEBUGFLAGS="${DEBUGFLAGS:--ggdb3}"
CFLAGS=-pipe
CXXFLAGS="$CFLAGS"
MAKEFLAGS=(-j 3 "CFLAGS=$CFLAGS" "CXXFLAGS=$CXXFLAGS" "OPTFLAGS=$OPTFLAGS"
    "DEBUGFLAGS=$DEBUGFLAGS")

# test suite location
export TEST_AND_DEV="$HOME/src/collab/test_and_dev"

cd "$DIR"

if [ "$NEW" ]; then
    make $MAKEFLAGS clean || true
    hg pull -u # get the latest changes
    if [ -d "$TEST_AND_DEV" ]]; then
        svn up "$TEST_AND_DEV"
    fi
    autoreconf -i
fi

# XXX: remove --with-LZERO after head gets merged back in (default of -1.0E17)
configure-home --with-logp=table --with-LZERO=-1.0E20
make "${MAKEFLAGS[@]}"
#make "${MAKEFLAGS[@]}" check # disabled until bugs fixed
make "${MAKEFLAGS[@]}" install
