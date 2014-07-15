#!/usr/bin/env bash

## push-www.sh: push Hoffman Lab www to www-external

## Copyright 2014 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset -o pipefail -o errexit

usage () {
    echo "usage: $0 [-l] [--without-linkchecker]"
    exit 2
}

check_links=1
optspec="hl-:"

while getopts "$optspec" optchar; do
    case "$optchar" in
        -)
            case "$OPTARG" in
                without-linkchecker)
                    check_links=
                    ;;
                *)
                    usage
            esac
            ;;
        l)
            check_links=
            ;;
        *)
            usage
            ;;
    esac
done

parent=/mnt/work1/users/hoffmangroup
src="${parent}/www"
dest="${parent}/www-external"

## commit
cd "$src"
hg commit || true

## test links
if [ "$check_links" ]; then
    linkchecker --check-css --check-html http://mordor/hoffmanlab/
fi

## push
hg push || true

## copy files
ssh mordor rsync --exclude .hg --exclude internal --archive --delete \
    --inplace "${src}/" "$dest"

## replace HTML files in-place
find "$dest" -name '*.html' \
    -execdir perl -i "$(type -p insert_google_analytics_footer.pl)" {} \;

## successful
echo "Copy successful. Email Qun to push $dest to external web server."
