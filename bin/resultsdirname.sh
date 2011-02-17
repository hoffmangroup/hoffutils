#!/usr/bin/env bash

## resultsdirname.sh: print directory name that mkresultsdir uses

## $Revision$
## Copyright 2011 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset
set -o pipefail
set -o errexit

if [ $# != 1 ]; then
    echo usage: "$0" DESCRIPTION
    exit 2
fi

DESCRIPTION="$1"

YEAR="$(date +%Y)"
MONTH="$(date +%m)"
DAY="$(date +%d)"

DIRNAME="$MONTH$DAY-$DESCRIPTION"

# if the current working directory is not $YEAR, then add it
if [ "$(basename "$PWD")" != "$YEAR" ]; then
    echo "$YEAR/$DIRNAME"
else
    echo "$DIRNAME"
fi
