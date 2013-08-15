#!/usr/bin/env bash

## makegmtk2.sh: make new GMTK

## $Revision$
## Copyright 2011, 2012, 2013 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset -o pipefail -o errexit -x

if [ $# != 0 ]; then
    echo usage: "$0" [DIR]
    echo DIR is the location of the GMTK source
    exit 2
fi

dir="${1:-$HOME/src/collab/gmtk}" # . for current dir

NEW="${NEW:-}"
MODULE="${MODULE:-}"
NCPUS="${NCPUS:-$(grep -c "^processor" /proc/cpuinfo)}"

module_root=/net/noble/vol1/software/modules-sw

# XXX: remove --with-LZERO after trunk gets merged back into ticket161
# (default of -1.0E17)
configureflags=(--with-logp=table --with-LZERO=-1.0E20)

# tuned for n017-n022 but should run on n001
# use qconf -sel | cat &lt;(hostname) - | xargs -n 1 -i bash -c 'ssh -o "StrictHostKeyChecking no" "{}" "echo -n "\$HOSTNAME "; gcc -march=native -E -v - </dev/null 2>&1 | fgrep cc1" || true'
# to get options, find intersection
# OPTFLAGS="${OPTFLAGS:--O3 -march=x86-64 -mcx16 -msahf -mno-movbe -mno-lwp -mno-fma -mno-fma4 -mno-xop -mno-bmi -mno-tbm -mno-avx --param l1-cache-size=32 --param l1-cache-line-size=64 --param l2-cache-size=12288 -mtune=corei7}"

OPTFLAGS="${OPTFLAGS:--O3 -march=x86-64 -mtune=generic}"

DEBUGFLAGS="${DEBUGFLAGS:--ggdb3}"
CFLAGS=-pipe
CXXFLAGS="$CFLAGS --std=c++0x"
MAKEFLAGS=(-j $(((NCPUS > 1) ? NCPUS-1 : 1)) "CFLAGS=$CFLAGS"
    "CXXFLAGS=$CXXFLAGS" "OPTFLAGS=$OPTFLAGS" "DEBUGFLAGS=$DEBUGFLAGS")

# test suite location
export TEST_AND_DEV="$(readlink -f "$dir/../test_and_dev")"

cd "$dir"

if [ "$NEW" ]; then
    make $MAKEFLAGS distclean || true
    hg pull -u || true # get the latest changes
    if [ -d "$TEST_AND_DEV" ]; then
        svn up "$TEST_AND_DEV" || true
    fi
    autoreconf -i
fi

if [ "$MODULE" ]; then
    module_version="$(hg id --branch)-$(hg id --id)"
    module_triple="$MODULES_OS/$MODULES_REL/$MODULES_MACH"
    prefix="$module_root/gmtk/$module_version/$module_triple"
    ./configure --prefix="$prefix" "${configureflags[@]}"
else
    if ! (./config.status --config | fgrep -- "'--prefix=$HOME'" \
          | fgrep -- "'--exec-prefix=$ARCHHOME'"); then
        ./configure --prefix="$HOME" --exec-prefix="$ARCHHOME" \
            "${configureflags[@]}"
    fi
fi

make "${MAKEFLAGS[@]}"
make "${MAKEFLAGS[@]}" check
make "${MAKEFLAGS[@]}" install
