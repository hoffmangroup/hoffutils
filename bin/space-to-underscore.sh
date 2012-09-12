#!/usr/bin/env bash

## space-to-underscore.sh: 

## $Revision$
## Copyright 2012 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset -o pipefail -o errexit

if [[ $# != 1 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo usage: "$0"
    exit 2
fi

file="$1"
svn mv "$file" "$(echo "$file" | sed -e 's/ /_/g')"
