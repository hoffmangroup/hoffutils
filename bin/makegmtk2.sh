#!/usr/bin/env bash

## makegmtk2.sh: make new GMTK

## $Revision$
## Copyright 2011, 2012 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset -o pipefail -o errexit
set -x

if [ $# != 0 ]; then
    echo usage: "$0" [DIR]
    echo DIR is the location of the GMTK source
    exit 2
fi

dir="${1:-$HOME/src/collab/gmtk}" # . for current dir

NEW="${NEW:-}"
NCPUS="${NCPUS:-$(grep -c "^processor" /proc/cpuinfo)}"

# tuned for n017-n022 but should run on n001
# use qconf -sel | cat &lt;(hostname) - | xargs -n 1 -i bash -c 'ssh -o "StrictHostKeyChecking no" "{}" "echo -n "\$HOSTNAME "; gcc -march=native -E -v - &lt;/dev/null 2&gt;&amp;1 | fgrep cc1" || true'
# to get options, find intersection

OPTFLAGS="${OPTFLAGS:--O3 -march=x86-64 -mcx16 -msahf -mno-movbe -mno-lwp -mno-fma -mno-fma4 -mno-xop -mno-bmi -mno-tbm -mno-avx --param l1-cache-size=32 --param l1-cache-line-size=64 --param l2-cache-size=12288 -mtune=corei7}"
DEBUGFLAGS="${DEBUGFLAGS:--ggdb3}"
CFLAGS=-pipe
CXXFLAGS="$CFLAGS"
MAKEFLAGS=(-j $(((NCPUS > 1) ? NCPUS-1 : 1)) "CFLAGS=$CFLAGS"
    "CXXFLAGS=$CXXFLAGS" "OPTFLAGS=$OPTFLAGS" "DEBUGFLAGS=$DEBUGFLAGS")

# test suite location
export TEST_AND_DEV="$(readlink -f "$dir/../test_and_dev")"

cd "$dir"

if [ "$NEW" ]; then
    make $MAKEFLAGS distclean || true
    hg pull -u || true # get the latest changes
    if [ -d "$TEST_AND_DEV" ]]; then
        svn up "$TEST_AND_DEV"
    fi
    autoreconf -i
fi

# XXX: remove --with-LZERO after trunk gets merged back into ticket156
# (default of -1.0E17)
configure-home --with-logp=table --with-LZERO=-1.0E20
make "${MAKEFLAGS[@]}"
#make "${MAKEFLAGS[@]}" check # disabled until bugs fixed
make "${MAKEFLAGS[@]}" install
