#!/usr/bin/env python3

# calutil

# Requirements:
# caldav
# click
#

from dataclasses import dataclass
from pathlib import Path
from typing import Any, List, Tuple
from urllib.parse import urlparse

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
    def type(self) -> str:
        if self.kind == 'ics':
            return self.raw.__class__.__name__
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
@click.argument('url', type=str)
@click.option('dry', '--dry/--live', is_flag=True, default=True)
def clean(url: str, dry):
    with caldav.DAVClient(url=url) as client:
        cal = pick_cal(url, client)
        do_clean(cal, dry)


@cli.command()
@click.argument('input', type=str)
@click.argument('output', type=str)
def convert(input, output):
    events, todos = do_read_ics(input)

    items = []
    items += events

    for t in todos:
        if t.has_due_date or t.has_start_date:
            items.append(t)
            # print(t)

    if len(items) == 0:
        print('exiting (no entries)')
        return

    with caldav.DAVClient(url=output) as client:
        cal = pick_cal(output, client)
        do_save_events(cal, items)


@cli.command()
@click.argument('input', type=str)
def dbg(input):
    events, todos = do_read_ics(input)
    for ev in todos:
        ev.print_dbg()
        print()


@cli.command()
@click.argument('url', type=str)
def count(url: str):
    with caldav.DAVClient(url=url) as client:
        cal = pick_cal(url, client)

        print('events/todos/total')
        print(do_count(cal))


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


def do_clean(cal: caldav.Calendar, dry: bool = True):
    click.echo("Deleting existing events")
    for ev in cal.events():
        print('deleting event', ev)
        if not dry:
            ev.delete()
    for t in cal.todos():
        print('deleting todo', t)
        if not dry:
            t.delete()


def do_count(cal: caldav.Calendar, dry: bool = True):
    len_ev = len(cal.events())
    len_todo = len(cal.todos())
    len_total = len_ev + len_todo
    return len_ev, len_todo, len_total


def do_save_events(cal: caldav.Calendar, events: List[Event]):
    for ev in events:
        click.echo(f"Writing entry ({ev.type}): {ev.name}")
        cal.save_event(ev.to_ical())


def pick_cal(url: str, client: caldav.DAVClient) -> caldav.Calendar:
    o = urlparse(url)

    principal = client.principal()
    for cal in principal.calendars():
        if urlparse(str(cal.url)).path == o.path:
            break
    else:
        cal = next(iter(principal.calendars()))

    click.echo(f"Using calendar {cal}")

    return cal


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
