#!/usr/bin/env bash

## img2fax.sh: convert an image to a TIFF-F fax file usable by Avaya CallPilot

## $Revision$
## Copyright 2014 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset -o pipefail -o errexit

if [[ $# != 1 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo usage: "$0" FILE
    exit 2
fi

file="$1"

convert "$file" -density 204x196 -units PixelsPerInch -alpha off \
    -antialias -resize '1728x2156!' -dither FloydSteinberg -monochrome \
    -compress fax "${file%.*}.tif"
