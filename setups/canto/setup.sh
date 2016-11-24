#!/usr/bin/env bash

packages=(
    aur:canto-{daemon,curses}
)

links=(
    {$DOTFILES"/setups/canto",$HOME"/.config/canto/plugins"}/sync-rsync.py
    {$DOTFILES"/setups/canto",$HOME"/.bin"}/canto-cursesl
)
