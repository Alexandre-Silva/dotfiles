#!/usr/bin/bash

packages=(
    "pm:qbittorrent"
    "pm:qbittorrent-nox"
)

links=()

st_install() {
    echo "Settig mime type associations"
    for mime in "x-scheme-handler/magnet" "application/x-bittorrent"; do
        xdg-mime default qbittorrent.desktop "${mime}"
    done
}
