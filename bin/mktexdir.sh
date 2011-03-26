#!/usr/bin/env bash

## mktexdir.sh: make a directory with TeX stuff in it

## $Revision$
## Copyright 2011 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset
set -o pipefail
set -o errexit
set -x

if [ $# != 1 ]; then
    echo usage: "$0" DIRNAME
    exit 2
fi

SRCDIR="$(dirname "$BASH_SOURCE")"
TEXDIR="$SRCDIR/../tex"
DIR="$1"

REALDIR="${DIR%%.manuscript}"
REPO="file:///net/noble/vol1/svn/$DIR/trunk"

svn mkdir --parents -m "new manuscript" "$REPO"
svn co "$REPO" "$REALDIR"

command cd "$REALDIR"

svn propset --file "$TEXDIR/ignore.txt" svn:ignore .
cp "$TEXDIR"/{manuscript,hypersetup,abstract,article,title}.tex .

svn add {manuscript,hypersetup,abstract,article,title}.tex
svn commit -m "initial checkout from template"

# XXX: add refs external
