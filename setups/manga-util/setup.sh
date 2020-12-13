#!/usr/bin/bash

packages=()

links=(
    {"$ADM_DIR/","$HOME/.bin/"}manga_rss.py
    "$ADM_DIR/manga_rss.py" "$HOME/.bin/manga_rss"
    {"$ADM_DIR/","$HOME/.bin/"}mangakakalot-scrapper.sh
    {"$ADM_DIR/","$HOME/.bin/"}mangakakalot-scrapper.py
    {"$ADM_DIR/","$HOME/.bin/"}mangadex-scrapper.py
    {"$ADM_DIR/","$HOME/.bin/"}mangadex-scrapper.sh
)


st_install() {
    systemctl --user link "$ADM_DIR/manga-rss.service"
}
