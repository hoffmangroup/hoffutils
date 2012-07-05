#!/usr/bin/env bash

## mktexdir.sh: make a directory with TeX stuff in it

## $Revision$
## Copyright 2011, 2012 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset -o pipefail -o errexit -x

if [ $# != 1 ]; then
    echo usage: "$0" DIRNAME
    exit 2
fi

srcdir="$(dirname "$BASH_SOURCE")"
texdir="$srcdir/../tex"
dir="$1"

realdir="${dir%%.manuscript}"
REPO="file:///net/noble/vol1/svn/$dir/trunk"

svn mkdir --parents -m "new manuscript" "$REPO"
svn co "$REPO" "$realdir"

command cd "$realdir"

svn propset --file "$texdir/ignore.txt" svn:ignore .
cp "$texdir"/{manuscript,hypersetup,abstract,article,title}.tex .

svn add {manuscript,hypersetup,abstract,article,title}.tex
svn commit -m "initial checkout from template"

# XXX: add refs external
