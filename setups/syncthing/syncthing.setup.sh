#!/bin/bash

packages=( "pm:syncthing"{,-gtk,-inotify} )

__config="${XDG_CONFIG_HOME:-$HOME/.config}"
links=(
    {"$DOTFILES/setups/syncthing","$__config/systemd/user"}/syncthing.service
    {"$DOTFILES/setups/syncthing","$__config/autostart/"}/Syncthing-GTK.desktop
)
