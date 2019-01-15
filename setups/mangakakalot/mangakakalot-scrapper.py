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
            tag.findAll('img') for tag in soup.findAll('div', id="vungdoc")
        ]

        def download_image(image_response, image_number, url):
            file_extension = url.split('.')[-1]
            path_directory = "{}/{}/{}/".format(out_dir, serie, chapter)
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
