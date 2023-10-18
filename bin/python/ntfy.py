#!/usr/bin/env python3

import os

import click
import requests

ADDR = os.environ.get("NTFY_ADDR")
TOKEN = os.environ.get("NTFY_TOKEN")

PRIORITIES = [
    (5, 'max', 'urgent'),
    (4, 'high'),
    (3, 'medium', 'default'),
    (2, 'low'),
    (1, 'min'),
]

PRIORITIES_MAP = {}

for p in PRIORITIES:
    for name in p[1:]:
        v = p[0]
        PRIORITIES_MAP[name] = v


@click.command()
@click.argument("topic")
@click.argument("message")
@click.option("title", "-t", "--title", type=str, help='if empty, defaults to topic name')
@click.option("attachment", "-a", "--attachment", type=str, help='include an attachment (like an image url)')
@click.option("priority",
              "-p",
              "--priority",
              type=click.Choice(PRIORITIES_MAP.keys()),
              default='default',
              help='message priority')
@click.option("tags", "-T", "--tags", type=str, help='comma seperated list of tags (e.g. warning, )')
@click.option("schedule", "--schedule", type=str, help='delay the delivery of messages; E.g. 30m, 3h, 2 days, 10am, 8:30pm, tomorrow, 3pm, Tuesday')
def main(topic, message, title, attachment, priority, tags, schedule):
    '''
    For a list of possible tags, see https://docs.ntfy.sh/emojis
    '''
    if not TOKEN:
        raise click.ClickException("NTFY_TOKEN is not defined")

    if not ADDR:
        raise click.ClickException("NTFY_ADDR is not defined")

    url = f'{ADDR}/{topic}'
    headers = {
        "Authorization": f"Bearer {TOKEN}",
    }

    if title:
        headers['Title'] = title

    if attachment:
        headers["Attach"] = attachment

    if priority:
        headers["Priority"] = str(PRIORITIES_MAP[priority])

    if tags:
        headers["Tags"] = tags

    if schedule:
        headers["Delay"] = schedule

    # headers.update({ "Tags": "warning,mailsrv13,daily-backup", })

    reply = requests.post(
        url,
        data=message,
        headers=headers,
    )

    if not reply.ok:
        raise click.ClickException(f"request failed: {reply} ({reply.text})")


if __name__ == "__main__":
    main(prog_name="ntfy", complete_var="_NTFY_COMPLETE", obj={})
