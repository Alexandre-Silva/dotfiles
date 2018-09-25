#!/usr/bin/bash

packages=(
    "pm:firefox"
)

links=()

if [[ -d ~/.mozilla/firefox ]]; then
    for dir in $(find ~/.mozilla/firefox -name '*.default' -type d); do
        links+=("${ADM_DIR}/userChrome.css" "${dir}/chrome/userChrome.css")
    done
fi
