#!/usr/bin/env python3

import subprocess
import sys
from datetime import datetime, timedelta, timezone
from pathlib import Path
from typing import Optional as Opt

import requests
import yaml

# NOTES:
# still needs qbittorrent photoprism filebrowser
# commit to suspend

config = {}


class SleepsMonitor():

    def __init__(self) -> None:
        self.wakeups = []
        self.suspends = []

    def fetch_data(self):

        out = subprocess.check_output(
            ['journalctl', '-b', '0', '--output', 'short-iso'])

        wakeups = []
        suspends = []

        for l in out.splitlines():
            # if b'PM: ' in l:
            # print(l)

            if b'PM: suspend exit' in l:
                wakeup_time = l.decode('ascii').split(' ')[0]
                wakeup_dt = datetime.fromisoformat(wakeup_time)
                wakeups.append(wakeup_dt)

            if b'PM: suspend entry' in l:
                suspend_time = l.decode('ascii').split(' ')[0]
                suspend_dt = datetime.fromisoformat(suspend_time)
                suspends.append(suspend_dt)

        self.wakeups, self.suspends = wakeups, suspends

    def last_wakeup(self) -> Opt[datetime]:
        if len(self.wakeups) == 0:
            return None

        return self.wakeups[-1]

    def suspends_iter(self):
        for i, (wakeup, suspend) in enumerate(zip(self.wakeups,
                                                  self.suspends)):
            yield (i, suspend, wakeup, wakeup - suspend)

    def suspends_print(self):
        for i, suspend, wakeup, dur in self.suspends_iter():
            print(f'{i}: {dur} -- {suspend} -> {wakeup}')


class CheckerLogins():

    def check(self) -> bool:
        out = subprocess.check_output(['who'])

        # ignore tmux
        lines = out.splitlines()
        lines = filter(lambda e: b'tmux' not in e, lines)
        lines = list(lines)

        return len(lines) > 0

    @property
    def name(self):
        return 'user_sessions'


class CheckerNavidrome():

    ENDPOINT_LOGIN = '/auth/login'
    ENDPOINT_PLAYERS = '/api/player'

    def __init__(
        self,
        name: str,
        username: str,
        password: str,
        url: str,
    ) -> None:
        self._name = name
        self.username = username
        self.password = password
        self.url = url

        self.token = None
        self.player_data = None

    def check(self) -> bool:
        '''
        We check if there's any player activity in the last 10min
        '''

        if not self.token:
            self.login()
            if self.token is None:
                print(f'{self.name}: failed to login')
                return False

        data = self.fetch_players()

        if len(data) == 0:  # NOTE never seen no clients
            return False

        last_seen_iter = map(lambda e: e['lastSeen'], data)
        last_seen_iter_dt = map(lambda x: datetime.fromisoformat(x),
                                last_seen_iter)
        last_seen = max(last_seen_iter_dt)

        delta = _now() - last_seen
        interval = timedelta(minutes=10)
        has_recent_activity = delta <= interval

        # print(has_recent_activity, delta, last_seen, interval)

        return has_recent_activity

    def login(self) -> Opt[str]:
        url = self.url + self.ENDPOINT_LOGIN
        out = requests.post(
            url,
            json={
                'username': self.username,
                'password': self.password
            },
        )
        # print(url)
        # print(out.status_code)
        # print(out.text)

        if out.status_code == 200:
            js = out.json()
            self.token = js['token']

        return self.token

    def fetch_players(self) -> Opt[str]:
        url = self.url + self.ENDPOINT_PLAYERS
        out = requests.get(
            url, headers={'x-nd-authorization': f'Bearer {self.token}'})

        # print(out.status_code)
        # print(out.text)

        if out.status_code != 200:
            return None

        #keys ['id', 'name', 'userAgent', 'userName', 'client', 'ipAddress', 'lastSeen', 'transcodingId', 'maxBitRate', 'reportRealPath', 'scrobbleEnabled']

        self.player_data = out.json()

        return self.player_data

    @property
    def name(self) -> str:
        return '{}'.format(self._name)


class CheckerJellyfin():

    ENDPOINT_DEVICES = '/Devices'

    # http GET https://jellyfin.alexcasa.duckdns.org/Devices 'api_key==[some key, see admin dashboard]'

    def __init__(
        self,
        name: str,
        key: str,
        url: str,
    ) -> None:
        self._name = name
        self.key = key
        self.url = url

        self.device_data = None

    def check(self) -> bool:
        '''
        We check if there's any device activity in the last 10min
        '''

        data = self.fetch_devices()

        if data is None:
            print(f'{self.name}: instance may be down')
            return False

        if len(data) == 0:  # NOTE never seen no clients
            return False

        iter = filter(lambda e: 'DateLastActivity' in e, data['Items'])
        last_seen_lst = [e['DateLastActivity'] for e in iter]
        if len(last_seen_lst) == 0:  # has devies but no activity
            return False

        last_seen_iter_dt = map(lambda x: datetime.fromisoformat(x),
                                last_seen_lst)
        last_seen = max(last_seen_iter_dt)

        delta = _now() - last_seen
        interval = timedelta(minutes=10)
        has_recent_activity = delta <= interval

        # print(has_recent_activity, delta, last_seen, interval)

        return has_recent_activity

    def fetch_devices(self) -> Opt[str]:
        url = self.url + self.ENDPOINT_DEVICES
        out = requests.get(url, params={'api_key': self.key})

        # print(out.status_code)
        # print(out.text)

        if out.status_code != 200:
            return None

        self.player_data = out.json()

        return self.player_data

    @property
    def name(self) -> str:
        return '{}'.format(self._name)


def main():
    global config
    config_fp = Path('/home/alex/.config/host-activity.yml')
    if config_fp.exists():
        with open(config_fp) as f:
            config = yaml.safe_load(f)

    sleep_monitor = SleepsMonitor()
    sleep_monitor.fetch_data()
    sleep_monitor.suspends_print()

    # now = datetime.now(tz=timezone.utc)
    # wk = sleep_monitor.last_wakeup()
    # if wk:
    #     print('{} ({})'.format(now - wk, wk))
    # else:
    #     print('none')

    checkers = [
        CheckerLogins(),
    ]

    for item in config.get('checkers', []):
        type_ = item['type']
        if type_ == 'navidrome':
            c = CheckerNavidrome(
                name=item['name'],
                username=item['username'],
                password=item['password'],
                url=item['url'],
            )
            checkers.append(c)

        elif type_ == 'jellyfin':
            c = CheckerJellyfin(
                name=item['name'],
                key=item['key'],
                url=item['url'],
            )
            checkers.append(c)
        else:
            print(f'unkown type {type_}')

    is_active = False

    for c in checkers:
        if c.check():
            print(f'> {c.name}')
            is_active = True

    if is_active:
        print('active')
        sys.exit(0)
    else:
        print('inactive')
        sys.exit(1)


def _now() -> datetime:
    return datetime.now(tz=timezone.utc)


if __name__ == "__main__":
    main()
