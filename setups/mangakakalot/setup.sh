#!/usr/bin/bash

packages=()

links=(
    {"$ADM_DIR/","${XDG_CONFIG_HOME:-$HOME/.config}/systemd/user/"}mangakakalot-rss.service
    {"$ADM_DIR/","$HOME/.bin/"}mangakakalot-rss
    {"$ADM_DIR/","$HOME/.bin/"}mangakakalot-scrapper.sh
)
