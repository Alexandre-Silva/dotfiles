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

    export XDG_DESKTOP_DIR
    export XDG_DOWNLOAD_DIR
    export XDG_TEMPLATES_DIR
    export XDG_PUBLICSHARE_DIR
    export XDG_DOCUMENTS_DIR
    export XDG_MUSIC_DIR
    export XDG_PICTURES_DIR
    export XDG_VIDEOS_DIR
    export XDG_CACHE_HOME
    export XDG_CONFIG_HOME
    export XDG_DATA_HOME
    export XDG_STATE_HOME

    source "$XDG_CONFIG_HOME/user-dirs.dirs"

    xdg-user-dirs-update
}

st_install() {
    export XDG_CONFIG_HOME="$HOME/.config"

    export XDG_DESKTOP_DIR
    export XDG_DOWNLOAD_DIR
    export XDG_TEMPLATES_DIR
    export XDG_PUBLICSHARE_DIR
    export XDG_DOCUMENTS_DIR
    export XDG_MUSIC_DIR
    export XDG_PICTURES_DIR
    export XDG_VIDEOS_DIR
    export XDG_CACHE_HOME
    export XDG_CONFIG_HOME
    export XDG_DATA_HOME
    export XDG_STATE_HOME

    source "$XDG_CONFIG_HOME/user-dirs.dirs"

    mkdir -vp $XDG_DESKTOP_DIR
    mkdir -vp $XDG_DOWNLOAD_DIR
    mkdir -vp $XDG_TEMPLATES_DIR
    mkdir -vp $XDG_PUBLICSHARE_DIR
    mkdir -vp $XDG_DOCUMENTS_DIR
    mkdir -vp $XDG_MUSIC_DIR
    mkdir -vp $XDG_PICTURES_DIR
    mkdir -vp $XDG_VIDEOS_DIR
    mkdir -vp $XDG_CACHE_HOME
    mkdir -vp $XDG_CONFIG_HOME
    mkdir -vp $XDG_DATA_HOME
    mkdir -vp $XDG_STATE_HOME

}
