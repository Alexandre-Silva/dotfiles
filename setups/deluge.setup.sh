#!/bin/zsh

packages=(
    pm:deluge
)

links=()

st_install() {
    # 1) Installs the plugin 'Default trackers' which adds a set of base
    # trackers to all new torrents. THerefore, initial peer and seeder finding
    # is much greater which minimizes warm-up period of a new torrent.
    #
    # 2) Adds a list of default trackers (after installing the plugin)

    local PLUGIN_DEFAULT_TRACKERS="https://github.com/stefantalpalaru/deluge-default-trackers"
    local deluge_conf="${XDG_CONFIG_DIRS:-$HOME/.config}/deluge"
    local deluge_plugins="$deluge_conf/plugins"

    git clone "$PLUGIN_DEFAULT_TRACKERS"

    mkdir --verbose --parents "$deluge_plugins"

    find "$deluge_plugins/" -name 'DefaultTrackers-*.egg' -delete
    cp deluge-default-trackers/egg/* "$deluge_plugins/"
}
