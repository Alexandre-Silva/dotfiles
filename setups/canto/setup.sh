#!/usr/bin/env bash

packages=(
    aur:canto-{daemon,curses}
)

links=(
    {$DOTFILES"/setups/canto",$HOME"/.config"}/sync-rsync.py
    {$DOTFILES"/setups/canto",$HOME"/.bin"}/canto-cursesl
)
