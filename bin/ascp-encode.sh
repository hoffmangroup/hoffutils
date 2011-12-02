#!/usr/bin/env bash

## ascp-encode.sh: sync files from encode-box-01

## $Revision$
## Copyright 2011 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset -o pipefail -o errexit -x

if [ $# != 1 ]; then
    echo usage: "$0" FILENAME >&2
    echo 'FILENAME is with respect to commonData (ex: "byDataType/signal/jan2011/genomedata.tier1-2")' >&2
    exit 2
fi

filename="$1"
local_dirname="$(dirname "$HOME/shortcuts/commonData/$filename")"

# -T: no encryption
# -k 3: don't resend identical files
# -k only works if target is a directory
# -Q: fair share bandwidth
# -d: create necessary directories
# -p: preserve timestamp

# for speed
if [ "${HOSTNAME##$HOSTNAME_SHORT}" != "grid.gs.washington.edu" ]; then
    ssh="ssh n001"
else
    ssh=
fi

$ssh bash -c "echo; ASPERA_SCP_PASS=enc*deDOWN ascp -TQdp -k 3 -l 400M \"encode-box-01@fasp.encode.ebi.ac.uk:$filename\" \"$local_dirname\""
