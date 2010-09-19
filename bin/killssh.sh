#!/usr/bin/env bash

grep --files-with-matches "^1$" /proc/*/ppid \
    | sed -e 's/ppid$/cmdline/' \
    | xargs perl -ne 'if (/^ssh\0/) {$ARGV =~ s#^/proc/(.+)/cmdline#\1#; kill "TERM", $ARGV}'
