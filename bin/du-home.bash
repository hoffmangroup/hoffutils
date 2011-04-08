#!/usr/bin/env bash

HARDMAX=1048576
let SOFTMAX=HARDMAX*3/4

HOME=${HOME:-/homes/hoffman}

TEMPFILE=$(mktemp)
du -k $HOME | sort -rn > $TEMPFILE
if [[ $(head -n 1 $TEMPFILE | cut -f 1 -d " ") > $SOFTMAX ]]; then \
    cat $TEMPFILE
fi
rm $TEMPFILE
