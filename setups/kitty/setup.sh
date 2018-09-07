#!/usr/bin/bash

packages=(
    "pm:kitty"
)

links=(
    {"$ADM_DIR/","${XDG_CONFIG_HOME:-$HOME/.config}/kitty/"}kitty.conf
)

st_profile() {
    if [ -n "$ZSH_VERSION" ]; then
        autoload -Uz compinit
    fi
}

st_rc() {
    if [ -n "$ZSH_VERSION" ]; then
        # Completion for kitty
        kitty + complete setup zsh | source /dev/stdin

    elif [ -n "$BASH_VERSION" ]; then
        source <(kitty + complete setup bash)
    fi
}
