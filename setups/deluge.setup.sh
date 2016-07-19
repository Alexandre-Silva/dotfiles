#!/bin/zsh

packages=(
    pm:deluge
)

links=()

st_install() {
    local PLUGIN_DEFAULT_TRACKERS="https://github.com/stefantalpalaru/deluge-default-trackers"
    local deluge_conf="${XDG_CONFIG_DIRS:-$HOME/.config}/deluge"
    local deluge_plugins="$deluge_conf/plugins"

    git clone "$PLUGIN_DEFAULT_TRACKERS"

    mkdir --verbose --parents "$deluge_plugins"

    find "$deluge_plugins/" -name 'DefaultTrackers-*.egg' -delete
    cp deluge-default-trackers/egg/* "$deluge_plugins/"
}
