#!/usr/bin/env bash

## vcall-all.sh: vcall for all the relevant directories

## $Revision$
## Copyright 2013 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset -o pipefail -o errexit

if [[ $# != 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo usage: "$0"
    exit 2
fi

vcall status ~/src ~/etc ~/jobs/2011 ~/jobs/2012 ~/jobs/statements \
    ~/public_html
