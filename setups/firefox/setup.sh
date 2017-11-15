#!/usr/bin/bash

packages=(
    "pm:firefox"
)

links=(
    /usr/share/gtags/gtags.conf $HOME/.globalrc
    "${ADM_DIR}/userChrome.css" ~/.mozilla/firefox/*.default/chrome/userChrome.css
)
