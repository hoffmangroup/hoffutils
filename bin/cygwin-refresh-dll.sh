#!/usr/bin/env ash

## cygwin-refresh-dll.sh: refresh all Cygwin DLLs
## run from ash (Run C:\cygwin\bin\ash.exe)

## $Revision$
## Copyright 2011 Michael M. Hoffman <mmh1@uw.edu>

PATH="$(dirname "$0"):$PATH"

cygrunsrv-all stop
keychain --stop all
rebaseall -v
peflagsall -v
keychain-add
cygrunsrv-all start
