import os
import sys
import cfscrape
from bs4 import *

SCRIPT_DIR = os.path.dirname(os.path.realpath(__file__))


def help():
    msg = """
    ######################################################
    Welcome, introduce the url, take care of all the parts (include the http or https)
    url example: http://manganelo.com/chapter/yakusoku_no_neverland/chapter_2
    Leave blank for exit
    ###################################################### """
    print(msg)


def main():
    out_dir = sys.argv[1]
    url = sys.argv[2]

    scrape = cfscrape.create_scraper()
    html = scrape.get(url).content
    soup = BeautifulSoup(html, features='lxml')

    # print([tag for tag in soup.findAll('div', class_="chapter-list")])
    chapter_list = list(soup.find('div', class_="chapter-list").findAll('a'))

    for c in chapter_list:
        # print(c.contents)
        print(c['href'])
    # print(chapter_list)


if __name__ == "__main__":
    main()
