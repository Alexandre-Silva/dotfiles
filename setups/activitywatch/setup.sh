#!/bin/bash

packages=(
    "aur:activitywatch-bin"
)

links=(
    {"$DOTFILES/setups/",$HOME"/.config/"}activitywatch
    "$AW_SYNC_DIR" "$HOME/ActivityWatchSync"
)

st_profile() {
  export AW_SYNC_DIR="$HOME/Documents/@sync/syncthing/application-data/ActivityWatch"
}


