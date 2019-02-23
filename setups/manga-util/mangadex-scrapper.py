#!/usr/bin/env python3

import os
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
        'https://mangadex.org/api/',
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
        chapter['chapter']: int(key)
        for key, chapter in manga_meta['chapter'].items()
        if chapter['lang_code'] == 'gb'
    }

    chapters = [chapter_num2id[chapter] for chapter in chapters]

    for chapter in chapters:
        result = scrape.get(
            'https://mangadex.org/api/',
            params={
                'id': chapter,
                'type': 'chapter'
            },
        )

        if not result.ok:
            print("ERROR: failed to fetch meta data")
            print(result)
            sys.exit(1)

        result = result.json()

        volume = int(result['volume']) if result['volume'].isdecimal() else 99
        chapter = int(result['chapter'])
        name = result['title']
        server = result['server']
        chapter_name = f'V{volume:02}.C{chapter:03}: {name}'

        chapter_hash = result['hash']
        image_list = [
            f'{server}{chapter_hash}/{name}'
            for name in result['page_array']
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
