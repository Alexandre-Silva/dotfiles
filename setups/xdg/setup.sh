#!/usr/bin/bash

packages=(
    "pm:xdg-user-dirs"
    "pm:xdg-utils"
)

links=(
    {"$DOTFILES/setups/xdg/",$HOME"/.config/"}user-dirs.dirs
)

st_profile() {
    export XDG_CONFIG_HOME="$HOME/.config"

    local NAMES=(
        DESKTOP
        DOWNLOAD
        TEMPLATES
        PUBLICSHARE
        DOCUMENTS
        MUSIC
        PICTURES
        VIDEOS
    )

    source "$XDG_CONFIG_HOME/user-dirs.dirs"

    for name in "${NAMES[@]}"; do
        export "XDG_${name}_DIR"
    done

    xdg-user-dirs-update
}
