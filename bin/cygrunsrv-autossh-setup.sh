#!/usr/bin/env bash

## cygrunsrv-autossh-setup.sh: set up cygrunsrv and autossh

## $Revision$
## Copyright 2011, 2014 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset -o pipefail -o errexit

if [[ $# != 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo usage: "$0"
    exit 2
fi

cygrunsrv --install autossh_nexus2_forward --disp "autossh nexus2_forward" --desc "Persistent ssh connection to nexus2_forward" --path /usr/bin/autossh --env "AUTOSSH_NTSERVICE=yes" --env "AUTOSSH_GATETIME=0" --env "AUTOSSH_PORT=0" --args nexus2_forward --user Michael
