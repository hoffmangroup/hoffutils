#!/usr/bin/env python
from __future__ import division

"""lsf_inspect_output.py: inspect output from LSF e-mails piped from Alpine
"""

__version__ = "$Revision$"

## Copyright 2011 Michael M. Hoffman <mmh1@uw.edu>

import sys

from optbuild import OptionBuilder
from path import path

REMOTE_HOST = "ebi-login"
EMACSCLIENT_PROG = OptionBuilder("emacsclient")

def get_lines():
    for line in sys.stdin:
        yield line.rstrip()

def get_until(lsep, rsep):
    for line in get_lines():
        head, lsep_found, tail = \
            line.partition(lsep)
        if lsep_found:
            rhead, rsep_found, rtail = \
                tail.partition(rsep)
            if rsep_found:
                return rhead

def make_tramp_filename(dirpath, filename):
    return "".join(["/", REMOTE_HOST, ":/", dirpath / filename])

def lsf_inspect_output():
    dirpath = path(get_until("<", "> was used as the working directory."))
    outfilename = get_until("Read file <", "> for stdout output of this job.")
    errfilename = get_until("Read file <", "> for stderr output of this job.")

    EMACSCLIENT_PROG(make_tramp_filename(dirpath, outfilename),
                     make_tramp_filename(dirpath, errfilename),
                     no_wait=True)

def parse_options(args):
    from optparse import OptionParser

    usage = "%prog [OPTION]..."
    version = "%%prog %s" % __version__
    parser = OptionParser(usage=usage, version=version)

    options, args = parser.parse_args(args)

    if not len(args) == 0:
        parser.error("incorrect number of arguments")

    return options, args

def main(args=sys.argv[1:]):
    options, args = parse_options(args)

    return lsf_inspect_output(*args)

if __name__ == "__main__":
    sys.exit(main())
