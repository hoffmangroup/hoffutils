#!/usr/bin/env bash

cd ~/printbox

date >> ~/printbox/.printed/printbox.log

for PRINTERNAME in *; do
    ssh farm-login ls "~/printbox/${PRINTERNAME}" && \
        scp farm-login:~/printbox/${PRINTERNAME}/* ${PRINTERNAME} && \
        ssh farm-login rm "~/printbox/${PRINTERNAME}/*"

    # XXX: blank if there are no files
    (echo
        echo ${PRINTERNAME}:
        ls -1 ${PRINTERNAME}) | tee --append ~/printbox/.printed/printbox.log
    for FILE in ${PRINTERNAME}/*; do
        # XXX: need to key on whether duplex in filename to set -o sides=two-sided-long-edge
        lpr -P${PRINTERNAME} "$FILE"
        mv "$FILE" .printed
    done
done

htmlview http://del.icio.us/grouse/.printbox &
