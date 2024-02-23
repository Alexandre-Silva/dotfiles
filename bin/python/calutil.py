#!/usr/bin/env python3

# Requirements:
# caldav

from dataclasses import dataclass
from pathlib import Path
from typing import Any, List, Tuple

import caldav
import click
import icalendar


@click.group()
def cli():
    pass


@dataclass
class Event():
    raw: Any
    kind: str

    @classmethod
    def from_icalendar(cls, ev):
        return Event(ev, 'ics')

    @property
    def name(self) -> str:
        if self.kind == 'ics':
            return self.raw.get("SUMMARY")
        else:
            raise AssertionError("unsupported Event kind {}".format(self.kind))

    @property
    def has_start_date(self) -> bool:
        if self.kind == 'ics':
            return 'DTSTART' in self.raw
        else:
            raise AssertionError("unsupported Event kind {}".format(self.kind))

    @property
    def has_due_date(self) -> bool:
        if self.kind == 'ics':
            return 'DUE' in self.raw
        else:
            raise AssertionError("unsupported Event kind {}".format(self.kind))

    def print_dbg(self):
        if self.kind == 'ics':
            print_ics_event(self.raw)
        else:
            raise AssertionError("unsupported Event kind {}".format(self.kind))

    def to_ical(self) -> str:
        if self.kind == 'ics':
            return self.raw.to_ical()
        else:
            raise AssertionError("unsupported Event kind {}".format(self.kind))


@cli.command()
@click.argument('input', type=str)
@click.argument('output', type=str)
@click.option('output_calendar',
              '--output-calendar',
              type=str,
              help='specify the calendar to use in the caldav server')
@click.option('do_clean',
              '--clean/--no-clean',
              is_flag=True,
              default=True,
              help='Should the output calendar be cleared before writing the events from input')
def convert(input, output, output_calendar, do_clean: bool):

    events, todos = do_read_ics(input)

    # ev = events[0]
    # click.echo(ev.raw.to_ical())
    # for ev in events:
    #     ev.print_dbg()
    #     print()
    #     break

    items = []
    items += events

    for t in todos:
        if t.has_due_date or t.has_start_date:
            items.append(t)

    with caldav.DAVClient(url=output) as client:
        principal = client.principal()
        print_caldav_calendars(principal.calendars())

        if output_calendar:
            cal = principal.calendar(name=output_calendar)
        else:
            cal = next(iter(principal.calendars()))

        click.echo(f"Using calendar {cal}")

        do_save_events(cal, items, do_clean)


@cli.command()
@click.argument('input', type=str)
def dbg(input):
    events, todos = do_read_ics(input)
    for ev in todos:
        ev.print_dbg()
        print()


def do_read_ics(input: str) -> Tuple[List[Event], List[Event]]:
    '''Returns calender events and todos'''

    ip = Path(input)
    if not ip.exists():
        raise click.ClickException(f"No input: {input}")

    with open(ip) as f:
        calender_in = icalendar.Calendar.from_ical(f.read())

    events = list(map(Event.from_icalendar, calender_in.walk('VEVENT')))
    todos = list(map(Event.from_icalendar, calender_in.walk('VTODO')))

    return events, todos


def do_save_events(cal: caldav.Calendar, events: List[Event], do_clean: bool):
    if do_clean:
        click.echo("Deleting existing events")
        for ev in cal.events():
            ev.delete()
        for t in cal.todos():
            t.delete()

    for ev in events:
        click.echo(f"Writing event: {ev.name}")
        cal.save_event(ev.to_ical())


def print_ics_event(ev: icalendar.Event):
    click.echo()
    click.echo(ev.get("SUMMARY"))
    for k, v in ev.items():
        if k == 'SUMMARY':
            continue
        click.echo("{}: {}".format(k, v))


def print_caldav_calendars(calendars):
    """
    This example prints the name and URL for every calendar on the list
    """
    if calendars:
        ## Some calendar servers will include all calendars you have
        ## access to in this list, and not only the calendars owned by
        ## this principal.
        click.echo("your principal has %i calendars:" % len(calendars))
        for c in calendars:
            click.echo("    Name: %-36s  URL: %s" % (c.name, c.url))
    else:
        click.echo("your principal has no calendars")


def main():
    cli()


if __name__ == "__main__":
    main()
