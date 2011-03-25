#!/usr/bin/env bash

NEWDIR="$HOME/shortcuts/current-quarter/$(date +%Y-%m-%d)"

mkdir -p "$NEWDIR"
chmod a+rx,ug+w "$NEWDIR"
cd "$NEWDIR"
target
