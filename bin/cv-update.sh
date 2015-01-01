#!/usr/bin/env bash

## cv-update.sh: update CV

## $Revision$
## Copyright 2014 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset -o pipefail -o errexit

if [[ $# != 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo usage: "$0"
    exit 2
fi

mv ~/Dropbox/Resume/Academic/cv-academic-short.pdf \
    ~/public_html/cv/michael-hoffman-cv.pdf
