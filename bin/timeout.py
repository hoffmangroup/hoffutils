#!/usr/bin/env python
from __future__ import division

"""
timeout: DESCRIPTION
"""

__version__ = "$Revision$"

# Copyright 2008 Michael M. Hoffman <mmh1@washington.edu>

import sys
from time import time

from pexpect import EOF, spawn

TIMEOUT = 60*60*24*365 # 1 year

def timeout(cmd, *args):
    start_time = time()

    child = spawn(cmd, list(args), TIMEOUT)

    while True:
        line = child.readline()

        if not line:
            break

        print "%0.2f:%s" % (time() - start_time, line.rstrip())

def parse_options(args):
    from optparse import OptionParser

    usage = "%prog [OPTION]... CMD [ARG...]"
    version = "%%prog %s" % __version__
    parser = OptionParser(usage=usage, version=version)

    options, args = parser.parse_args(args)

    if not len(args) >= 1:
        parser.print_usage()
        sys.exit(1)

    return options, args

def main(args=sys.argv[1:]):
    #options, args = parse_options(args)

    return timeout(*args)

if __name__ == "__main__":
    sys.exit(main())
