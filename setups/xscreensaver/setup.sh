#!/bin/bash

packages=(
    'pm:xscreensaver'
)

links=(
    {"$DOTFILES/setups/xscreensaver/",$HOME"/."}xscreensaver
    {"$DOTFILES/setups/xscreensaver/",$HOME"/.config/systemd/user/"}xscreensaver.service
)

st_install(){
    systemctl --user daemon-reload
    systemctl --user enable xscreensaver
    systemctl --user restart xscreensaver
}
