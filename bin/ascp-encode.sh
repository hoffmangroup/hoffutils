#!/usr/bin/env bash

## ascp-encode.sh: mirror files from encode-box-01 to noble lab commonData

## $Revision$
## Copyright 2011, 2012 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset -o pipefail -o errexit

if [ $# != 1 ]; then
    echo usage: "$0" FILENAME >&2
    echo 'FILENAME is with respect to commonData (ex: "byDataType/signal/jan2011/genomedata.tier1-2")' >&2
    exit 2
fi

# must have aspera module loaded

filename="$1" # must do this one at a time, use xargs -n 1 if you want multiple
dirname=/net/noble/vol3/data/encode/commonData

[ -d "$dirname" ] # this must exist

# $local_dirname might be a child of $dirname
local_filename="$dirname/$filename"
local_dirname="$(dirname "$local_filename")"

# -T: no encryption
# -k 3: don't resend identical files
# -k only works if target is a directory
# -Q: fair share bandwidth
# -d: create necessary directories
# -p: preserve timestamp

# n001 is closer to the fileserver in the network
domain_name="${HOSTNAME#*.}"
if [ "$domain_name" != "grid.gs.washington.edu" ]; then
    maybe_ssh="ssh n001"
else
    maybe_ssh=
fi

# echo is so output isn't eaten by ssh
$maybe_ssh bash -c \
    "echo; ASPERA_SCP_PASS=enc*deDOWN ascp -TQdp -k 3 -l 400M \"encode-box-01@fasp.encode.ebi.ac.uk:$filename\" \"$local_dirname\""

chmod --silent --recursive ug+rw "$local_filename"
