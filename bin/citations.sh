#!/usr/bin/env bash

## citations.sh: get citation counts for documents that appear in Michael's CV

## $Revision$
## Copyright 2014 Michael M. Hoffman <mmh1@uw.edu>

set -o nounset -o pipefail -o errexit

if [[ $# != 0 || "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
    echo usage: "$0"
    exit 2
fi

clusters="4093658096001256548 13001593243986802887 15095633921325465716 \
    4104465607589170180 2212123465360216007 13335646528637046132 \
    13513706827883771845"

# XXX: sort in reverse year order. current order is:

#          Title Unsupervised pattern discovery in human chromatin structure through genomic segmentation
#            URL http://www.nature.com/nmeth/journal/v9/n5/abs/nmeth.1937.html
#           Year 2012
#      Citations 95
#       Versions 0
#     Cluster ID 4093658096001256548
# Citations list http://scholar.google.com/scholar?cites=4093658096001256548&as_sdt=2005&sciodt=0,5&hl=en

#          Title An integrated encyclopedia of DNA elements in the human genome
#            URL http://www.nature.com/nature/journal/v489/n7414/abs/nature11247.html
#           Year 2012
#      Citations 1979
#       Versions 0
#     Cluster ID 13001593243986802887
# Citations list http://scholar.google.com/scholar?cites=13001593243986802887&as_sdt=2005&sciodt=0,5&hl=en

#          Title Sequence and comparative analysis of the chicken genome provide unique perspectives on vertebrate evolution
#            URL http://www.nature.com/nature/journal/v432/n7018/abs/nature03154.html
#           Year 2004
#      Citations 1491
#       Versions 0
#     Cluster ID 15095633921325465716
# Citations list http://scholar.google.com/scholar?cites=15095633921325465716&as_sdt=2005&sciodt=0,5&hl=en

#          Title A user&#39;s guide to the encyclopedia of DNA elements (ENCODE)
#            URL http://dx.plos.org/10.1371/journal.pbio.1001046.g008
#           Year 2011
#      Citations 548
#       Versions 0
#     Cluster ID 4104465607589170180
# Citations list http://scholar.google.com/scholar?cites=4104465607589170180&as_sdt=2005&sciodt=0,5&hl=en

#          Title ChIP-seq guidelines and practices of the ENCODE and modENCODE consortia
#            URL http://genome.cshlp.org/content/22/9/1813.short
#           Year 2012
#      Citations 203
#       Versions 0
#     Cluster ID 2212123465360216007
# Citations list http://scholar.google.com/scholar?cites=2212123465360216007&as_sdt=2005&sciodt=0,5&hl=en

#          Title AANT: The amino acidânucleotide interaction database
#            URL http://nar.oxfordjournals.org/content/32/suppl_1/D174.short
#           Year 2004
#      Citations 93
#       Versions 0
#     Cluster ID 13335646528637046132
# Citations list http://scholar.google.com/scholar?cites=13335646528637046132&as_sdt=2005&sciodt=0,5&hl=en

#          Title Integrative annotation of chromatin elements from ENCODE data
#            URL http://nar.oxfordjournals.org/content/early/2012/12/05/nar.gks1284.short
#           Year 2012
#      Citations 57
#       Versions 0
#     Cluster ID 13513706827883771845
# Citations list http://scholar.google.com/scholar?cites=13513706827883771845&as_sdt=2005&sciodt=0,5&hl=en



for cluster in $clusters; do
    "$HOME/sandbox/scholar.py/scholar.py" --count=1 --cluster-id="$cluster"
done
