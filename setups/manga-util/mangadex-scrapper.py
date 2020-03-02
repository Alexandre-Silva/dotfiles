#!/usr/bin/env python3

import os
import time
import sys
import cfscrape
from bs4 import BeautifulSoup
import re
from typing import Optional

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))


def main():
    out_dir = sys.argv[1]
    manga_id = sys.argv[2]
    chapters = sys.argv[3:]

    scrape = cfscrape.create_scraper()

    manga_meta = scrape.get(
        'https://mangadex.cc/api/',
        params={
            'id': int(manga_id),
            'type': 'manga'
        },
    )

    if not manga_meta.ok:
        print('Error fetching meta data for id:', manga_id)
        sys.exit(1)

    manga_meta = manga_meta.json()
    print("Manga:", manga_meta['manga']['title'])

    chapter_num2id = {
        chapter['chapter']: key
        for key, chapter in manga_meta['chapter'].items()
        if chapter['lang_code'] == 'gb'
    }

    chapters = [chapter_num2id[chapter] for chapter in chapters]

    for chapter in chapters:
        while True:
            result = scrape.get(
                'https://mangadex.cc/api/',
                params={
                    'id': chapter,
                    'type': 'chapter'
                },
            )
            if result.status_code == 500:
                print("error code 500: waiting 5 secs before trying again")
                time.sleep(5)
                continue

            break

        if not result.ok:
            print("ERROR: failed to fetch meta data")
            print(result)
            sys.exit(1)

        result = result.json()
        print(result)

        chapter_hash = result['hash']
        volume = int(result['volume']) if result['volume'].isdecimal() else 99
        chapter = result['chapter']
        name = result['title']
        server = result['server']

        chapter_split = chapter.split('.')
        if len(chapter_split) == 1:
            chapter_num = int(chapter)
            chapter_name = f'C{chapter_num:03}: {name}'
        else:
            chapter_num, chapter_sub = chapter_split
            chapter_num, chapter_sub = int(chapter_num), int(chapter_sub)
            chapter_name = f'C{chapter_num:03}.{chapter_sub}: {name}'

        if not server.startswith('http'):
            server = f'https://mangadex.cc{server}'

        image_list = [
            f'{server}{chapter_hash}/{name}' for name in result['page_array']
        ]

        for i, img_url in enumerate(image_list):
            print(f'Fetching {chapter_name} page {i+1}/{len(image_list)}')
            image_response = scrape.get(img_url)

            file_extension = img_url.split('.')[-1]
            path_directory = "{}/{}/".format(out_dir, chapter_name)
            file_name = "{}.{}".format("%03d" % (i + 1, ), file_extension)

            # print(path_directory + file_name)
            # return

            if image_response.status_code == 200:
                if not os.path.exists(path_directory):
                    os.makedirs(path_directory)
                with open(path_directory + file_name, 'wb') as out_file:
                    for data in image_response:
                        out_file.write(data)
                    # print(path_directory + file_name)
            else:
                print('Error downloading:', img_url,
                      image_response.status_code)
                sys.exit(1)


if __name__ == "__main__":
    main()
