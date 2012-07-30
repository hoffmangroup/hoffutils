#!/usr/bin/env bash

## system-config-printer-applet-wrapper.sh: print wrapper with system python

## $Revision$
## Copyright 2012 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset -o pipefail -o errexit

if [[ $# != 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo usage: "$0"
    exit 2
fi

module unload python
PYTHONPATH= system-config-printer-applet
