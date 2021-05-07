#!/bin/bash

packages=(
    "pm:alacritty"
    "pm:ttf-inconsolata"
)

links=(
    {"$DOTFILES/setups/",$HOME"/.config/"}alacritty
)

st_install() {
    true;
}
