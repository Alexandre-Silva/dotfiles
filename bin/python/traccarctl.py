#!/usr/bin/env python3

import os
from datetime import datetime, timedelta, timezone
from typing import Any, Dict, Tuple

import requests

ROOT = 'https://traccar.genoaspark.com'
SERVER_ENDPOINT = 'api/server'
DEVICES_ENDPOINT = 'api/devices'
REPORTS_ENDPOINT = 'api/reports/events'
ROUTES_ENDPOINT = 'api/reports/route'
TOKEN = os.environ['TRACCAR_TOKEN']


class TraccarCTL():

    def __init__(self, token: str, root: str) -> None:
        self.token = token
        self.root = root

    def _get(self, endpoint, params=None) -> Dict[str, Any]:
        url = f"{self.root}/{endpoint}"

        response = requests.get(
            url,
            headers={
                'Authorization': f'Bearer {self.token}',
                'Accept': 'application/json'
            },
            params=params,
        )

        if not response.ok:
            print(response.text)
            raise Exception(f"Request failed: {response}")

        return response.json()

    def get_reports(self, dev_id: int, tfrom: datetime, tto: datetime) -> Dict[str, Any]:
        print(tfrom.isoformat())
        return self._get(REPORTS_ENDPOINT, {
            'deviceId': dev_id,
            'from': tfrom.isoformat(),
            'to': tto.isoformat(),
        })

    def get_routes(self, dev_id: int, tfrom: datetime, tto: datetime) -> Dict[str, Any]:

        return self._get(ROUTES_ENDPOINT, {
            'deviceId': dev_id,
            'from': tfrom.isoformat(),
            'to': tto.isoformat(),
        })


def tension_to_soc(tension) -> float:
    ''' to [0-1.0] percentage and assumes 12v lead-acid battery'''
    levels = [
        (1.00, 12.73),
        (0.90, 12.62),
        (0.80, 12.50),
        (0.70, 12.37),
        (0.60, 12.24),
        (0.50, 12.10),
        (0.40, 11.96),
        (0.30, 11.81),
        (0.20, 11.66),
        (0.10, 11.51),
    ]

    if tension > levels[0][1]:
        return 1.0
    elif tension <= levels[-1][1]:
        return 0.0

    lvl_top, lvl_bottom = None, None
    for ref_soc, ref_tension in levels:
        if ref_tension > tension:
            lvl_bottom = ref_soc, ref_tension

        if ref_tension < tension and lvl_top is None:
            lvl_top = ref_soc, ref_tension

    # y = mX + b
    m = (lvl_top[0] - lvl_bottom[0]) / (lvl_top[1] - lvl_bottom[1])
    b = lvl_top[0] - m * lvl_top[1]

    soc = m * tension + b

    requests.post(json={})
    return soc


def do_fetch_last_soc(ctl: TraccarCTL, dev_name) -> Tuple[datetime, float, float, dict]:
    """
    @returns
        time of last msg,
        tension in vols
        soc in 0-1.0,
        raw msg
    """

    dev_id: int | None = None
    out = ctl._get(DEVICES_ENDPOINT)
    for obj in out:
        if obj['name'] != dev_name:
            continue

        dev_id = int(obj['id'])
        break

    if dev_id is None:
        raise Exception(f"Failed to find dev: {dev_name}")

    now, delta = datetime.now(tz=timezone.utc), timedelta(hours=3)
    tfrom, tto = now - delta, now
    out = ctl.get_routes(dev_id, tfrom, tto)

    obj = out[-1]
    # print(obj)
    tension = obj['attributes']['power']
    soc = tension_to_soc(tension)
    print(obj['serverTime'], round(tension, 3), soc)

    time = datetime.fromisoformat(obj['serverTime'])

    return time, tension, soc, obj


def main():
    ctl = TraccarCTL(TOKEN, ROOT)
    return (do_fetch_last_soc(ctl, 'Mota Alex'))


if __name__ == "__main__":
    main()
