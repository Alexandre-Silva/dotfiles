#!/usr/bin/env python3

import os
from datetime import datetime
import json
import sys
import requests
import cfscrape
from tabulate import tabulate
import pprint
from bs4 import BeautifulSoup
import re
from typing import Optional, List
from pathlib import Path

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
CACHE_DIR = Path(os.getenv('XDG_CACHE_DIR', '~/.cache/')).expanduser()
CACHE_FILE = CACHE_DIR / 'ipma.json'

URL_API = 'https://api.ipma.pt'
URL_ROOT = 'https://ipma.pt'

URL_RAINTYPES = f'{URL_ROOT}/bin/file.data/raintypes.json'
URL_WINDTYPES = f'{URL_ROOT}/bin/file.data/windtypes.json'
URL_WEATHERTYPES = f'{URL_ROOT}/bin/file.data/weathertypes.json'
URL_LOCATIONS = f'{URL_API}/public-data/forecast/locations.json'

URL_WARNINGS = f'{URL_API}/public-data/warnings/warnings_www.json'
URL_FORECASTS = f'{URL_API}/public-data/forecast/aggregate'

#### ENV params ####
LOCATIONS = os.getenv('IPMA_LOCATIONS', '')  #

pp = pprint.PrettyPrinter(indent=4)


def fetch_static() -> dict:
    types = [
        ('rain', URL_RAINTYPES),
        ('wind', URL_WINDTYPES),
        ('weather', URL_WEATHERTYPES),
        ('locations', URL_LOCATIONS),
    ]

    return {name: requests.get(url).json() for name, url in types}


def fetch_warnings() -> dict:
    url = URL_WARNINGS
    return requests.get(url).json()


def fetch_forecast(location_id: str) -> dict:
    url = f'{URL_FORECASTS}/{location_id}.json'
    return requests.get(url).json()


def cache_save(data: dict):
    with open(CACHE_FILE, 'w') as f:
        json.dump(data, f)


def cache_load() -> dict:
    with open(CACHE_FILE, 'r') as f:
        data = json.load(f)

    return data


def fetch() -> dict:
    data = dict()
    data['time'] = datetime.now().replace(microsecond=0).isoformat()
    static = fetch_static()
    warnings = fetch_warnings()

    data.update(static)
    data['warnings'] = warnings

    data['forecasts'] = {}

    return data


def forecast_setTime(f: dict):
    t = f['dataPrev']
    t = datetime.fromisoformat(t)
    f['time'] = t


def forecast_removeWhere(forecast: List[dict], **kwargs) -> List[dict]:
    idxs = set()
    for i, f in enumerate(forecast):
        for k, v in kwargs.items():
            if f[k] != v:
                break

            idxs.add(i)

    idxs = [i for i in idxs]
    idxs.sort(reverse=True)
    for i in idxs:
        del forecast[i]

    return forecast


def forecast_classifyPart(f: dict) -> dict:
    t = f['time']

    if t.hour >= 22 or t.hour < 6:
        f['part'] = 'night'
    elif t.hour >= 6 and t.hour < 14:
        f['part'] = 'morning'
    elif t.hour >= 14 and t.hour < 22:
        f['part'] = 'afternoon'
    else:
        assert False


def forecast_str2py(f: dict) -> None:
    for k in ('tMin', 'tMax', 'tMed', 'probabilidadePrecipita', 'utci',
              'ffVento', 'hR'):
        if k in f:
            f[k] = float(f[k])


def forecast_merge(a: dict, b: dict) -> dict:
    '''
    Joins two forecast by worst case scenario
    '''

    first = lambda a, b: a

    ag_fn = {
        'dataPrev': first,
        'dataUpdate': first,
        'ddVento': first,
        'ffVento': max,
        'globalIdLocal': first,
        'hR': max,
        'iUv': max,
        'idFfxVento': max,
        'idIntensidadePrecipita': max,
        'idPeriodo': first,
        'idTipoTempo': max,
        'intervaloHora': first,
        'part': first,
        'probabilidadePrecipita': max,
        'tMax': max,
        'tMed': max,
        'tMin': min,
        'time': min,
        'utci': min,
    }

    for k in a.keys():
        assert k in ag_fn, f'{k} not found'

    out = {}
    out.update(
        {k: fn(a[k], b[k])
         for k, fn in ag_fn.items() if k in a and k in b})
    out.update({k: a[k] for k in a.keys() if k not in b})
    out.update({k: b[k] for k in b.keys() if k not in a})
    return out


def forecast_aggregateByPart(forecast: List[dict]) -> List[dict]:
    out = []

    last = None
    for e in forecast:

        if last is None:
            last = e

        elif last['part'] != e['part']:
            out.append(last)
            last = None

        else:
            last = forecast_merge(last, e)

    if last is not None:
        out.append(last)

    return out


def forecast_resolveTypes(f: dict, rain, wind, weather, locations) -> None:
    if 'idTipoTempo' in f:
        f['tempo'] = weather[f['idTipoTempo']]

    if 'idFfxVento' in f:
        f['vento'] = weather[f['idFfxVento']]


class IPMA():
    def __init__(self, i18n='EN'):
        self.i18n = i18n

        self.data = {}
        self.time: Optional[datetime] = None  # when data was fetched

        self.map_rain = {}
        self.map_wind = {}
        self.map_weather = {}
        self.map_locations = {}

    def load(self, data: dict) -> None:
        self.data.update(data)

        if data == {}:
            return

        self.time = datetime.fromisoformat(data['time'])

        for name, m in (
            ('rain', self.map_rain),
            ('wind', self.map_wind),
            ('weather', self.map_weather),
        ):
            for k, v in data[name].items():
                m[int(k)] = v[self.i18n]

        self.map_locations = {loc['local']: loc for loc in data['locations']}

    def location_id(self, loc) -> str:
        return str(self.map_locations[loc]['globalIdLocal'])

    def forecast_fetch(self, location: str) -> dict:
        loc_id = self.location_id(location)
        forecast = fetch_forecast(loc_id)
        self.data['forecasts'][loc_id] = forecast

        return forecast

    def forecast_3parts(self, location: str) -> List[dict]:
        loc_id = self.location_id(location)
        forecast = self.data['forecasts'][loc_id]
        forecast = [f.copy() for f in forecast]

        for f in forecast:
            forecast_str2py(f)
            forecast_setTime(f)
            forecast_classifyPart(f)

        forecast = forecast_removeWhere(forecast, idPeriodo=24)
        forecast = forecast_aggregateByPart(forecast)

        for f in forecast:
            forecast_resolveTypes(
                f,
                self.map_rain,
                self.map_wind,
                self.map_weather,
                self.map_locations,
            )

        return forecast


def main():
    if len(sys.argv) <= 1:
        print("Needs to specify command")
        sys.exit(1)

    cmd = sys.argv[1]

    ipma = IPMA()
    if CACHE_FILE.exists():
        data = cache_load()
        ipma.load(data)

    if cmd == 'fetch-static':
        data = fetch()
        ipma.load(data)

    elif cmd == 'fetch-locations':
        locations = LOCATIONS.split(';')
        for loc in locations:
            f = ipma.forecast_fetch(loc)
            # pp.pprint(f)

    elif cmd == 'show-data':
        data = ipma.data

        if len(sys.argv) >= 3:
            name = sys.argv[2]
            data = data[name]

        pp.pprint(data)

    elif cmd == 'show-data-forecast':
        data = ipma.data

        name = sys.argv[2]

        locid = ipma.location_id(name)
        pp.pprint(data['forecasts'][locid])

    elif cmd == 'forecast':
        name = sys.argv[2]
        out = ipma.forecast_3parts(name)

        headers = ('day', 'part', 'tempo', 'probChuva', 'vento', 'ventoDir')
        rows = ((
            f['time'].strftime('%d %a'),
            f['part'],
            f['tempo'],
            int(f['probabilidadePrecipita']),
            f.get('ffVento', 0.0),
            f.get('ddVento'),
        ) for f in out)

        print(tabulate(rows, headers, disable_numparse=True))

    else:
        print(f"Unknown command {cmd}")

    cache_save(ipma.data)


if __name__ == "__main__":
    main()
