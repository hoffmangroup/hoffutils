#!/usr/bin/env bash

## ascp-encode.sh: sync files from encode-box-01

## $Revision$
## Copyright 2011 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset
set -o pipefail
set -o errexit

if [ $# != 1 ]; then
    echo usage: "$0" FILENAME >&2
    echo FILENAME is with respect to commonData "byDataType/signal/jan2011/genomedata.tier1-2" >&2
    exit 2
fi

# XXX: ensure running on a cluster node (ends on .grid.gs.washington.edu)

FILENAME="$1"
LOCALDIRNAME="$(dirname "$HOME/shortcuts/commonData/$FILENAME")"

# -T: no encryption
# -k 3: don't resend identical files
# -k only works if target is a directory
# -Q: fair share bandwidth
# -d: create necessary directories
# -p: preserve timestamp
ASPERA_SCP_PASS=enc*deDOWN ascp -TQdp -k 3 -l 400M \
    "encode-box-01@fasp.encode.ebi.ac.uk:$FILENAME" "$LOCALDIRNAME"
