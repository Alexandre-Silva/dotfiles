#!/usr/bin/env python3

import json
import os
import pprint
import sys
from datetime import datetime, timedelta
from pathlib import Path
from typing import Iterable, List, Optional

import click
import requests
import tabulate
from tabulate import tabulate as tb

tabulate.PRESERVE_WHITESPACE = True

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))
CACHE_DIR = Path(os.getenv("XDG_CACHE_DIR", "~/.cache/")).expanduser()
CACHE_FILE = CACHE_DIR / "ipma.json"

URL_API = "https://api.ipma.pt"
URL_ROOT = "https://ipma.pt"

URL_RAINTYPES = f"{URL_ROOT}/bin/file.data/raintypes.json"
URL_WINDTYPES = f"{URL_ROOT}/bin/file.data/windtypes.json"
URL_WEATHERTYPES = f"{URL_ROOT}/bin/file.data/weathertypes.json"
URL_LOCATIONS = f"{URL_API}/public-data/forecast/locations.json"

URL_WARNINGS = f"{URL_API}/public-data/warnings/warnings_www.json"
URL_FORECASTS = f"{URL_API}/public-data/forecast/aggregate"

pp = pprint.PrettyPrinter(indent=4)


def fetch_static_maps() -> dict:
    types = [
        ("rain", URL_RAINTYPES),
        ("wind", URL_WINDTYPES),
        ("weather", URL_WEATHERTYPES),
        ("locations", URL_LOCATIONS),
    ]

    return {name: requests.get(url).json() for name, url in types}


def fetch_warnings() -> dict:
    url = URL_WARNINGS
    return requests.get(url).json()


def fetch_forecast(location_id: str) -> dict:
    url = f"{URL_FORECASTS}/{location_id}.json"
    return requests.get(url).json()


def cache_save(data: dict):
    with open(CACHE_FILE, "w") as f:
        json.dump(data, f)


def cache_load() -> dict:
    with open(CACHE_FILE, "r") as f:
        data = json.load(f)

    return data


def fetch_static() -> dict:
    data = dict()
    data["time"] = datetime.now().replace(microsecond=0).isoformat()
    static = fetch_static_maps()
    warnings = fetch_warnings()

    data.update(static)
    data["warnings"] = warnings

    data["forecasts"] = {}

    return data


def forecast_setTime(f: dict):
    t = f["dataPrev"]
    t = datetime.fromisoformat(t)
    f["time"] = t


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
    t = f["time"]

    if t.hour >= 22 or t.hour < 6:
        f["part"] = "night"
    elif t.hour >= 6 and t.hour < 14:
        f["part"] = "morning"
    elif t.hour >= 14 and t.hour < 22:
        f["part"] = "afternoon"
    else:
        assert False


def forecast_str2py(f: dict) -> None:
    for k in (
        "tMin",
        "tMax",
        "tMed",
        "probabilidadePrecipita",
        "utci",
        "ffVento",
        "hR",
    ):
        if k in f:
            f[k] = float(f[k])


def forecast_merge(a: dict, b: dict) -> dict:
    """
    Joins two forecast by worst case scenario
    """

    first = lambda a, b: a
    avg = lambda a, b: (a + b / 2)

    for k in ("tempAguaMar", "periodoPico", "ondulacao", "marTotal", "periodOndulacao"):
        if k in a:
            a[k] = float(a[k])

        if k in b:
            b[k] = float(b[k])

    ag_fn = {
        "dataPrev": first,
        "dataUpdate": first,
        "ddVento": first,
        "ffVento": max,
        "globalIdLocal": first,
        "hR": max,
        "iUv": max,
        "idFfxVento": max,
        "idIntensidadePrecipita": max,
        "idPeriodo": first,
        "idTipoTempo": max,
        "intervaloHora": first,
        "part": first,
        "probabilidadePrecipita": max,
        "tMax": max,
        "tMed": max,
        "tMin": min,
        "time": min,
        "utci": min,
        "tempAguaMar": avg,
        "periodoPico": max,
        "ondulacao": max,
        "dirOndulacao": first,
        "marTotal": max,
        "periodOndulacao": max,
    }

    for k in a.keys():
        assert k in ag_fn, f"{k}:{a[k]} not found"

    out = {}
    out.update({k: fn(a[k], b[k]) for k, fn in ag_fn.items() if k in a and k in b})
    out.update({k: a[k] for k in a.keys() if k not in b})
    out.update({k: b[k] for k in b.keys() if k not in a})
    return out


def forecast_aggregateByPart(forecast: List[dict]) -> List[dict]:
    out = []

    last = None
    for e in forecast:

        if last is None:
            last = e

        elif last["part"] != e["part"]:
            out.append(last)
            last = None

        else:
            last = forecast_merge(last, e)

    if last is not None:
        out.append(last)

    return out


def forecast_resolveTypes(f: dict, rain, wind, weather, locations) -> None:
    if "idTipoTempo" in f:
        f["tempo"] = weather[f["idTipoTempo"]]

    if "idFfxVento" in f:
        f["vento"] = weather[f["idFfxVento"]]


class IPMA:
    def __init__(self, i18n="EN"):
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

        self.time = datetime.fromisoformat(data["time"])

        for name, m in (
            ("rain", self.map_rain),
            ("wind", self.map_wind),
            ("weather", self.map_weather),
        ):
            for k, v in data[name].items():
                m[int(k)] = v[self.i18n]

        self.map_locations = {loc["local"]: loc for loc in data["locations"]}

    def location_id(self, loc) -> str:
        return str(self.map_locations[loc]["globalIdLocal"])

    def location_all(self) -> Iterable[str]:
        return self.map_locations.keys()

    def update_location(self, location: str) -> dict:
        loc_id = self.location_id(location)
        forecast = fetch_forecast(loc_id)
        self.data["forecasts"][loc_id] = forecast

        return forecast

    def forecast_date(self, location: str) -> Optional[datetime]:
        """
        Of the time it was produced by IPMA. If has it locally
        """
        loc_id = self.location_id(location)
        forecasts = self.data["forecasts"].get(loc_id)
        if forecasts is None:
            return None

        time = datetime.fromisoformat(forecasts[0]["dataUpdate"])

        return time

    def forecast_3parts(
        self,
        location: str,
        from_: datetime,
        to: datetime,
    ) -> List[dict]:

        loc_id = self.location_id(location)
        forecast = self.data["forecasts"][loc_id]
        forecast = [f.copy() for f in forecast]

        for f in forecast:
            forecast_str2py(f)
            forecast_setTime(f)
            forecast_classifyPart(f)

        forecast = filter(lambda f: f["time"] >= from_, forecast)
        forecast = filter(lambda f: f["time"] <= to, forecast)
        forecast = list(forecast)
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


ipma = IPMA()

if CACHE_FILE.exists():
    data = cache_load()
    ipma.load(data)

@click.group()
def cli():
    """
    CLI tool for Instituto Português do Mar e da Atmosfera


    \b
    Completion with click-completion
    E.g.
    `_IPMA_COMPLETE=source_zsh ipma > ~/.config/shell/completion_ipma.zsh`

    """
    pass


@cli.result_callback()
def on_return(ret):
    cache_save(ipma.data)


@cli.command()
def update():
    """
    Updates ipma meta data (such as locations or weather code id-name mappings)
    """
    data = fetch_static()
    ipma.load(data)


@cli.command()
@click.argument("location", type=str)
def update_location(location):
    """
    Fetches the latest forecast of LOCATION from IPMA servers
    """
    f = ipma.update_location(location)


@cli.command()
def list_location():
    """Lists all know localtions"""
    for l in ipma.location_all():
        click.echo(l)


@cli.command()
@click.argument("key", type=str, default="")
def dump_data(key):
    data = ipma.data

    if key != "":
        key_parts = key.split(".")
        for part in key_parts:
            if part not in data:
                click.echo(f"Unkown key {key}")
                sys.exit(1)

            data = data[part]

    pp.pprint(data)


@cli.command()
# @click.argument("location", type=str)
@click.argument("location", type=click.Choice(list(ipma.location_all())))
@click.option("--auto-update/--no-auto-update", default=True)
@click.option("short_parts", "--short-parts/--long-parts", default=False)
@click.option(
    "start",
    "--start",
    type=click.Choice(("all", "now")),
    default="all",
)
@click.option(
    "end",
    "--end",
    type=click.Choice(("all", "+0", "+1", "+2", "+3", "+4", "+5", "+6")),
    default="all",
)
def forecast(location, auto_update, short_parts: bool, start: str, end: str):
    """Show forecast for a LOCATION using fetched data


    For updating the fectched data use the '--auto-update' or 'ipma
    update-location' command.

    NOTE IPMA runs 2 forecast simulations daily. and thus publishs them twice
    daily. Hence the 12hour stale check.

    """

    if ipma.data == {}:
        if auto_update:
            ipma.load(fetch_static())
        else:
            click.echo("No available data and auto-update is off", err=True)

    now = datetime.now()
    forecast_date = ipma.forecast_date(location)
    is_non_existent = forecast_date is None
    td12h = timedelta(hours=12)
    is_stale = forecast_date is not None and forecast_date < (now - td12h)
    should_update = auto_update and (is_non_existent or is_stale)

    if should_update:
        ipma.update_location(location)

    now = datetime.now()

    if start == "all":
        start_dt = datetime(1, 1, 1)
    elif start == "now":
        start_dt = now
    else:
        assert False

    if end == "all":
        end_dt = datetime(3000, 1, 1)  # TODO in the year 3000 update this
    elif end.startswith("+"):
        end = end.replace("+", "")
        end_days = int(end)

        # NOTE To include todays night partion the end_dt will be the last day
        # plust the next one until 6:00
        today = now.replace(hour=6, minute=0, second=0)
        end_dt = today + timedelta(days=end_days + 1)
    else:
        assert False

    out = ipma.forecast_3parts(location, start_dt, end_dt)

    if short_parts:
        for f in out:
            f["part"] = f["part"][:3]

    # headers = ('day', 'part', 'tempo', 'probChuva', 'vento', 'ventoDir')
    rows = (
        (
            "{} {}".format(f["time"].strftime("%d %a"), f["part"]),
            "{:2d}% {}".format(int(f["probabilidadePrecipita"]), f["tempo"]),
            "{:>2} {:4.1f}".format(f.get("ddVento", ""), f.get("ffVento", 0.0)),
        )
        for f in out
    )

    click.echo(tb(rows, tablefmt="plain", disable_numparse=True))


def main():
    cli()


if __name__ == "__main__":
    main()
