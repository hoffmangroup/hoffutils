#!/usr/bin/env bash

VERSION=${1:-20091016}
OLDVERSION=20091004
MODDIR=/net/noble/vol1/software/modules/gmtk
MODFILE="$MODDIR/$VERSION"

if [ ! -e "$MODFILE" ]; then
    sed -e "s/$OLDVERSION/$VERSION/g" "$MODDIR/$OLDVERSION" > "$MODFILE"
fi

makegmtk.sh $VERSION
ssh n001 bash -c "\"makegmtk.sh $VERSION\""
ssh sage bash -c "\"makegmtk.sh $VERSION\""
