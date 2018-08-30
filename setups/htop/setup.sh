#!/bin/bash

packages=(
    'pm:htop'
)

links=(
    {"$DOTFILES/setups/",$HOME"/.config/"}htop
    {"$DOTFILES/setups/htop/",$HOME"/.bin/"}htopl
)

function st_rc() {
    if hash htop &>/dev/null; then alias top='htop'; fi
}
