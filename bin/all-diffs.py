#!/usr/bin/env python
from __future__ import division

"""all-diffs.py: display all diffs for a file in Subversion
"""

__version__ = "$Revision$"

## Copyright 2012 Michael M. Hoffman <mmh1@uw.edu>

import sys
from xml.etree import ElementTree

from optbuild import OptionBuilder

SVN_PROG = OptionBuilder("svn")

def all_diffs(filename):
    xml = SVN_PROG.getoutput("log", "--xml", filename)
    log = ElementTree.fromstring(xml)
    revisions = [logentry.attrib["revision"] for logentry in log]
    revisions.reverse()

    print "Index: %s (original revision %s)" % (filename, revisions[0])
    print "==================================================================="
    sys.stdout.flush()
    SVN_PROG("cat", "--revision=%s" % revisions[0], filename)

    for revision0, revision1 in zip(revisions[0:], revisions[1:]):
        revision_range = "%s:%s" % (revision0, revision1)
        SVN_PROG("diff", "--revision=%s" % revision_range, filename)

def parse_options(args):
    from optparse import OptionParser

    usage = "%prog [OPTION]... FILE"
    version = "%%prog %s" % __version__
    parser = OptionParser(usage=usage, version=version)

    options, args = parser.parse_args(args)

    if not len(args) == 1:
        parser.error("incorrect number of arguments")

    return options, args

def main(args=sys.argv[1:]):
    options, args = parse_options(args)

    return all_diffs(*args)

if __name__ == "__main__":
    sys.exit(main())
