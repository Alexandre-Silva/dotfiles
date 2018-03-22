#!/usr/bin/env bash

packages=(
    "pm:xorg" # group, not actual package
    "pm:xorg-drivers" # group, not actual package
)

links=(
    {"$DOTFILES/setups/xorg/",$HOME"/."}xinitrc
    {"$DOTFILES/setups/xorg/",$HOME"/."}Xresources
)
