#!/usr/bin/env python3

import os
import sys
from http.server import BaseHTTPRequestHandler, HTTPServer
from typing import Iterable, Tuple, Optional
from datetime import datetime

import cfscrape
from bs4 import BeautifulSoup
from feedgenerator import DefaultFeed

# from feedgen.feed

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))


def feed() -> DefaultFeed:
    return DefaultFeed(
        title='mangakakalot - Boarding School Juliet',
        link='https://mangakakalot.com/manga/kishuku_gakkou_no_juliet',
        description=
        'Simple feed via scrapping for manga mangakakalot Boarding School Juliet',
        logo=
        'https://avt.mkklcdnv3.com/avatar_225/16547-kishuku_gakkou_no_juliet.jpg',
        # fg.subtitle('This is a cool feed!')
        # fg.link( href='http://larskiesow.de/test.atom', rel='self' )
        language='en',
    )


def add_entries(fg: DefaultFeed, entries: Iterable[Tuple[str, str, str, Optional[datetime]]]) -> None:
    for e in entries:
        fg.add_item(
            title=e[0],
            link=e[1],
            description=e[2],
            pubdate=e[3],
        )


def feed_fetch_mangakakalot(url) -> str:
    print(f'Fetching {url}')

    scrape = cfscrape.create_scraper()
    html = scrape.get(url).content
    soup = BeautifulSoup(html, features='lxml')

    # print([tag for tag in soup.findAll('div', class_="chapter-list")])
    # print(soup.find('div'))
    chapter_list = soup.find('div',
                             class_="panel-story-chapter-list").findAll('a')

    fg = feed()
    add_entries(fg, ((c.contents[0], c['href'], '', None) for c in chapter_list))

    return fg.writeString("iso-8859-1")


def feed_fetch_mangadex(manga_id: int) -> Optional[str]:
    print(f'Fetching mangadex {manga_id}')

    scrape = cfscrape.create_scraper()

    manga_meta_resp = scrape.get(
        f'https://api.mangadex.org/manga/{manga_id}', )
    if not manga_meta_resp.ok:
        print('Error fetching meta data for id:', manga_id)
        return None

    manga_meta = manga_meta_resp.json()
    manga_title = manga_meta['data']['attributes']['title']['en']

    fg = DefaultFeed(
        title=f'mangadex - {manga_title}',
        link=f'https://mangadex.org/title/{manga_id}',
        description=f'Simple feed via scrapping for mangadex - {manga_title}',
        logo=f'https://mangadex.org/images/manga/{manga_id}.jpg',
        language='en',
    )

    chapters_resp = scrape.get(
        f'https://api.mangadex.org/manga/{manga_id}/feed',
        params={'locales[]': ['en'], 'limit': 500})

    if not chapters_resp.ok:
        print(f'Error fetching chapters for {manga_title} ({manga_id})')
        return None

    chapters_json = chapters_resp.json()

    def chapters_iter():
        for chapter in chapters_json['results']:
            data = chapter['data']
            if data['type'] != 'chapter':
                continue

            id_ = data['id']
            number = data['attributes']['chapter']
            title = data['attributes']['title']
            publish_at = datetime.fromisoformat(data['attributes']['publishAt'])

            yield id_, number, title, publish_at

    chapters = ((f'Chapter {number}: {title}',
                 f'https://mangadex.org/chapter/{id_}',
                 f'{manga_title}<br/>id: {id_}<br/>published at: {published_at.strftime("%Y-%m-%d")}',
                 published_at)
                for id_, number, title, published_at in chapters_iter())

    add_entries(fg, chapters)

    return fg.writeString("iso-8859-1")


class RSSHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        manga = self.path

        try:
            if manga.startswith('/mangadex/'):
                manga_id = manga.replace('/mangadex/', '')
                response = feed_fetch_mangadex(manga_id)

            elif manga.startswith('/mangakakalot/'):
                manga_name = manga.replace('/mangakakalot/', '')
                url = f'https://manganelo.com/manga/{manga_name}'
                response = feed_fetch_mangakakalot(url)

            else:
                print("Invalid path")
                response = None
        except:
            print('error for ' + manga)
            raise

        if response is None:
            self.send_response(500)
            return

        self.send_response(200)
        self.send_header("Content-type", "text/xml")
        self.end_headers()
        self.wfile.write(response.encode('utf-8'))


def main():
    server_address = ('127.0.0.1', 9001)
    httpd = HTTPServer(server_address, RSSHandler)
    httpd.serve_forever()


if __name__ == "__main__":
    main()
