#!/usr/bin/env bash

## cygrunsrv-autossh-setup.sh: set up cygrunsrv and autossh

## $Revision$
## Copyright 2011 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset
set -o pipefail
set -o errexit

if [[ $# != 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo usage: "$0"
    exit 2
fi

#!/usr/bin/env bash

## cygrunsrv-autossh-setup.sh: set up cygrunsrv and autossh

## $Revision$
## Copyright 2011 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset
set -o pipefail
set -o errexit

if [[ $# != 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo usage: "$0"
    exit 2
fi

cygrunsrv --install autossh_nexus2_forward --disp "autossh nexus2_forward" --desc "Persistent ssh connection to nexus2_forward" --path /usr/bin/autossh --env "AUTOSSH_NTSERVICE=yes" --env "AUTOSSH_GATETIME=0" --env "AUTOSSH_PORT=0" --args nexus2_forward --user Michael
cygrunsrv --install autossh_methionine_forward --disp "autossh methionine_forward" --desc "Persistent ssh connection to methionine_forward" --path /usr/bin/autossh --env "AUTOSSH_NTSERVICE=yes" --env "AUTOSSH_GATETIME=0" --env "AUTOSSH_PORT=0" --args methionine_forward --user Michael
