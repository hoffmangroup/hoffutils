#!/usr/bin/env bash

## push-www.sh: push Hoffman Lab www to www-external

## $Revision$
## Copyright 2014 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset -o pipefail -o errexit

if [[ $# != 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo usage: "$0"
    exit 2
fi

parent=/mnt/work1/users/hoffmangroup
src="${parent}/www"
dest="${parent}/www-external"

## commit
cd "$src"
hg commit || true

## test links
linkchecker --check-css --check-html http://mordor/hoffmanlab/

## push
hg push || true

## copy files
ssh mordor rsync --exclude .hg --archive --delete --inplace "${src}/" "$dest"

## replace HTML files in-place
find "$dest" -name '*.html' \
    -execdir perl -i "$(type -p insert_google_analytics_footer.pl)" {} \;

## successful
echo "Copy successful. Email Qun to push $dest to external web server."
