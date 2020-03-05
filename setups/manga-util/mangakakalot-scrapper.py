#!/usr/bin/env python3

import os
import sys
import cfscrape
from bs4 import BeautifulSoup
import re
from typing import Optional

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))


def help():
    msg = """
    ######################################################
    Welcome, introduce the url, take care of all the parts (include the http or https)
    url example: http://manganelo.com/chapter/yakusoku_no_neverland/chapter_2
    Leave blank for exit
    ###################################################### """
    print(msg)


# CHAPTER_NAME_RE = re.compile(r'^\w+ Vol.11 Chapter 71: \(\W+\) - Mangakakalot.com')
CHAPTER_NAME_1_RE = re.compile(
    r'^.+ Vol.(\d+) Chapter (\d+)\ ?:? (.+) - \w+.com')

CHAPTER_NAME_2_RE = re.compile(r'^.+ Chapter (\d+)\ ?:? (.+) - \w+.com')

CHAPTER_NAME_3_RE = re.compile(r'^.+ Chapter (\d+)\ ?:? (.+) - Manganelo')


def format_chapter_name_3(title: str) -> Optional[str]:
    match = CHAPTER_NAME_3_RE.match(title)

    if match is None:
        return None

    chapter, name = match.groups()
    chapter = int(chapter)

    return f'VXX.C{chapter:03}: {name}'

def format_chapter_name_2(title: str) -> Optional[str]:
    match = CHAPTER_NAME_2_RE.match(title)

    if match is None:
        return None

    chapter, name = match.groups()
    chapter = int(chapter)

    return f'VXX.C{chapter:03}: {name}'


def format_chapter_name_1(title: str) -> Optional[str]:
    match = CHAPTER_NAME_1_RE.match(title)

    if match is None:
        return None

    volume, chapter, name = match.groups()
    volume, chapter = int(volume), int(chapter)

    return f'V{volume:02}.C{chapter:03}: {name}'


def format_chapter_name(title: str) -> Optional[str]:
    for fn in [
            format_chapter_name_1,
            format_chapter_name_2,
            format_chapter_name_3,
    ]:
        name = fn(title)
        if name is not None:
            name = name.replace('Online For Free', '')
            name = name.strip()
            if name.endswith(':'):
                name += ' NA'
            return name

    return None


_formated = format_chapter_name(
    'Kishuku Gakkou No Juliet Vol.11 Chapter 71: Romio And The Freshmen II - Mangakakalot.com'
)
_expected = 'V11.C071: Romio And The Freshmen II'
assert _formated == _expected

_formated = format_chapter_name(
    'Kaguya-sama Wa Kokurasetai - Tensai-tachi No Renai Zunousen Chapter 21 : Kaguya Wants To Have Held Online For Free - MangaNelo.com'
)
_expected = 'VXX.C021: Kaguya Wants To Have Held'
assert _formated == _expected

_formated = format_chapter_name(
    'Kaguya-sama Wa Kokurasetai - Tensai-tachi No Renai Zunousen Vol.6 Chapter 60 Online For Free - MangaNelo.com'
)
_expected = 'V06.C060: NA'
assert _formated == _expected


def main():
    out_dir = sys.argv[1]
    urls = sys.argv[2:]

    for url in urls:
        if len(url) < 1: break
        http, empty, page, string, serie, chapter = url.split("/")
        print('Downloading:', serie, chapter)

        chapter = chapter.replace('chapter_', '')

        scrape = cfscrape.create_scraper()
        html = scrape.get(url).content
        soup = BeautifulSoup(html, features='lxml')

        image_list = [
            tag.findAll('img') for tag in soup.findAll('div', class_="container-chapter-reader")
        ]

        chapter_name = format_chapter_name(soup.title.string)
        if chapter_name is None:
            chapter_name = "NAME NOT FOUND"


        def download_image(image_response, image_number, url):
            file_extension = url.split('.')[-1]
            path_directory = "{}/{}/".format(out_dir, chapter_name)
            file_name = "{}.{}".format("%03d" % (image_number, ),
                                       file_extension)

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
                print('Error:', image_response.status_code)

        counter = 0
        for img in image_list[0]:
            download_image(scrape.get(img['src']), counter, img['src'])
            counter += 1


if __name__ == "__main__":
    main()
