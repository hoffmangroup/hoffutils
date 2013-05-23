#!/usr/bin/env ash

## cygwin-refresh-dll.sh: refresh all Cygwin DLLs
## run from ash (Run C:\cygwin\bin\ash.exe)

## $Revision$
## Copyright 2011, 2013 Michael M. Hoffman <mmh1@uw.edu>

PATH="$(dirname "$0"):$PATH"

# XXX: is there a dbus process that isn't getting killed?

cygrunsrv-all stop
keychain --stop all

# XXX: check that ps results are almost empty here

rebaseall -v
peflagsall -v

keychain-add
cygrunsrv-all start
