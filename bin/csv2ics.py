#!/usr/bin/env python
from __future__ import division, print_function

"""csv2ics.py: convert CSV agenda to iCalendar format
"""

## TODO:
##
## deal with timezones appropriately

__version__ = "$Revision$"

## Copyright 2013 Michael M. Hoffman <mmh1@uw.edu>

from csv import DictReader
from datetime import date, datetime
from hashlib import sha256
import sys

YEAR_DEFAULT = 1900

def print_field(key, value):
    if value:
        print(key, value, sep=":")

def print_alarm(trigger):
    print("""BEGIN:VALARM
ACTION:DISPLAY
DESCRIPTION:This is an event reminder
TRIGGER:%s
END:VALARM""" % trigger)

def transform_fieldname(name):
    res = name.lower()
    res = res.replace(" ", "_")
    return res

def get_date(row):
    res = datetime.strptime(row["date"], "%d-%b").date()

    if res.year == YEAR_DEFAULT:
        today_year = date.today().year
        res = res.replace(year=today_year)

    return res

def get_time(row, fieldname):
    text = row[fieldname]

    return datetime.strptime(text, "%I:%M:%S %p").time()

def get_dt(date, time):
    return datetime.combine(date, time).strftime("%Y%m%dT%H%M%S")

def get_dtstart(row):
    row_date = get_date(row)
    row_time = get_time(row, "time")

    return get_dt(row_date, row_time)

def get_dtend(row, next_row):
    row_date = get_date(row)

    if row["end_time"]:
        row_time = get_time(row, "end_time")
    else:
        row_time = get_time(next_row, "time")

    return get_dt(row_date, row_time)

def make_uid(*texts):
    return sha256("\0".join(texts)).hexdigest()

def write_events(rows):
    for row_index, row in enumerate(rows):
        try:
            next_row = rows[row_index+1]
        except IndexError:
            next_row = None

        dtstart = get_dtstart(row)
        dtend = get_dtend(row, next_row)
        location = row["location"]
        summary = row["description"]
        description = row["notes"]

        uid = make_uid(dtstart, dtend, location, summary, description)

        print_field("BEGIN", "VEVENT")
        print_field("DTSTART", dtstart)
        print_field("DTEND", dtend)
        print_field("UID", uid)
        print_field("LOCATION", location)
        print_field("SUMMARY", summary)
        print_field("DESCRIPTION", description)
        print_alarm("-P0DT0H5M0S")
        print_alarm("-P0DT0H10M0S")
        print_field("END", "VEVENT")

def csv2ics(filename):
    print_field("BEGIN", "VCALENDAR")

    with open(filename) as infile:
        reader = DictReader(infile)
        reader.fieldnames = [transform_fieldname(name)
                             for name in reader.fieldnames]
        rows = [row for row in reader]
        write_events(rows)

    print_field("END", "VCALENDAR")

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

    return csv2ics(*args)

if __name__ == "__main__":
    sys.exit(main())
