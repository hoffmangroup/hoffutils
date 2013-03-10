#!/usr/bin/env python
from __future__ import division, print_function

"""csv2ics.py: convert CSV agenda to iCalendar format

requires pytz

timezone can be anything supported by pytz, such as "EST" or "US/Eastern"

if you don't specify a timezone, times will not be converted. Google
Calendar imports these times in your current local Google Calendar time
"""

__version__ = "$Revision$"

## Copyright 2013 Michael M. Hoffman <mmh1@uw.edu>

from csv import DictReader
from datetime import date, datetime
from hashlib import sha256
import sys

from pytz import timezone, utc

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

def get_date(row, last_date):
    row_date = row["date"]

    if not row_date:
        return last_date # continue with date from previous row

    res = datetime.strptime(row_date, "%d-%b").date()

    if res.year == YEAR_DEFAULT:
        today_year = date.today().year
        res = res.replace(year=today_year)

    return res

def get_time(row, fieldname):
    text = row[fieldname]
    text = text.upper()
    text = text.replace("A.M.", "AM")
    text = text.replace("P.M.", "PM")

    try:
        dt = datetime.strptime(text, "%I:%M:%S %p")
    except ValueError:
        try:
            dt = datetime.strptime(text, "%I:%M %p")
        except ValueError:
            dt = datetime.strptime(text, "%H:%M")

    return dt.time()

def get_dt(date, time, tz):
    dt = datetime.combine(date, time)
    fmt = "%Y%m%dT%H%M%S"

    if tz:
        dt = tz.localize(dt).astimezone(utc)
        fmt += "Z"

    return dt.strftime(fmt)

def get_dtstart(row, date, tz):
    row_time = get_time(row, "time")

    return get_dt(date, row_time, tz)

def get_dtend(row, next_row, date, tz):
    if row["end_time"]:
        row_time = get_time(row, "end_time")
    else:
        row_time = get_time(next_row, "time")

    return get_dt(date, row_time, tz)

def make_uid(*texts):
    return sha256("\0".join(texts)).hexdigest()

def write_events(rows, tz):
    if tz:
        tz = timezone(tz)

    date = None

    for row_index, row in enumerate(rows):
        try:
            next_row = rows[row_index+1]
        except IndexError:
            next_row = None

        date = get_date(row, date)
        dtstart = get_dtstart(row, date, tz)
        dtend = get_dtend(row, next_row, date, tz)
        location = row["location"]
        summary = row["description"]
        description = row.get("notes", "")

        uid = make_uid(dtstart, dtend, location, summary, description)

        print_field("BEGIN", "VEVENT")
        print_field("DTSTART", dtstart)
        print_field("DTEND", dtend)
        print_field("UID", uid)
        print_field("LOCATION", location)
        print_field("SUMMARY", summary)
        print_field("DESCRIPTION", description)
        print_alarm("-P0DT0H10M0S")
        print_field("END", "VEVENT")

def csv2ics(filename, tz=None):
    print_field("BEGIN", "VCALENDAR")

    with open(filename) as infile:
        reader = DictReader(infile)
        reader.fieldnames = [transform_fieldname(name)
                             for name in reader.fieldnames]
        rows = [row for row in reader]
        write_events(rows, tz)

    print_field("END", "VCALENDAR")

def parse_options(args):
    from optparse import OptionParser

    usage = "%prog [OPTION]... FILE"
    version = "%%prog %s" % __version__
    parser = OptionParser(usage=usage, version=version)
    parser.add_option("-t", "--timezone", metavar="TZ", help="use timezone TZ"
                      " (default: no timezone)")

    options, args = parser.parse_args(args)

    if not len(args) == 1:
        parser.error("incorrect number of arguments")

    return options, args

def main(args=sys.argv[1:]):
    options, args = parse_options(args)

    return csv2ics(*args, tz=options.timezone)

if __name__ == "__main__":
    sys.exit(main())
