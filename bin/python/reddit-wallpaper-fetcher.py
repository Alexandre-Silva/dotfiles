#!/usr/bin/env python3

import requests
import string
import sys
from dataclasses import dataclass
from typing import List
import json
import os
from pathlib import Path
from datetime import datetime, timedelta

INDEX_URL = 'https://www.reddit.com/r/EarthPorn.json'
CACHE_PATH = Path('~/.cache/wallpapers/').expanduser()
WALLPAPER_MAX_COUNT = 30
WALLPAPER_DOWNLOAD_COUNT = 5
WALLPAPER_REMOVE_AGE = timedelta(days=5)
# WALLPAPER_REMOVE_AGE = timedelta(minutes=1)
printable = set(string.printable)


def str_rm_non_printable(s: str) -> str:
    return ''.join(filter(lambda x: x in printable, s))


@dataclass
class Post():
    title: str
    score: str
    url: str

    raw: dict

    @property
    def fname(self):
        ext = self.url.split('?')[0]
        ext = ext.split('.')[-1]
        title = self.title[:128]  # truncate long names
        title = str_rm_non_printable(title)
        title = title.replace('/', '')
        return f'{title}.{ext}'

    def __str__(self):
        return self.title


def main():
    cache = init_cache()
    posts = fetch_posts(INDEX_URL)
    posts2dl = determine_wp_to_download(cache, posts)

    for p in posts2dl:
        dowload_post(p)


def init_cache() -> List[Path]:
    '''
    @returns list of cached wallpapers
    '''

    if not CACHE_PATH.exists():
        CACHE_PATH.mkdir(parents=True)

    for f in CACHE_PATH.iterdir():
        s = f.stat()
        dt = datetime.fromtimestamp(s.st_mtime)
        now = datetime.now()
        age = WALLPAPER_REMOVE_AGE
        if ((now - dt) > age):
            f.unlink()

    wallpapers = list(CACHE_PATH.iterdir())

    return wallpapers


def fetch_posts(url: str) -> List[Post]:
    r = requests.get(
        url,
        headers={'User-agent': 'wallpaper-downloader-bot'},
    )
    index = r.json()

    posts = []
    for c in index['data']['children']:
        p = c['data']

        if p['is_meta'] or p.get('post_hint') != 'image':
            continue

        p = Post(p['title'], int(p['score']), p['url'], p)
        posts.append(p)

    return posts


def determine_wp_to_download(cache, posts: List[Post]) -> List[Post]:
    num2download = WALLPAPER_MAX_COUNT - len(cache)
    num2download = min(num2download, WALLPAPER_DOWNLOAD_COUNT)
    posts.sort(key=lambda p: p.score, reverse=True)
    posts = posts[:num2download]
    return posts


def dowload_post(post: Post):
    print(f'Dowloading: {post.title} (post.url)')

    rimg = requests.get(post.url,
                        headers={'User-agent': 'wallpaper-downloader-bot'})

    if not rimg.ok:
        print(f'Download failed ({rimg.status_code})')
        return

    img = rimg.content

    fpimg = CACHE_PATH / post.fname
    fpimg.write_bytes(img)


if __name__ == '__main__':
    main()
