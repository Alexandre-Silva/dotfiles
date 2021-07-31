#!/usr/bin/bash

packages=(
    "pm:neovim"
    "pm:python-neovim"
)

links=()

function st_install() {
    curl -sLf https://spacevim.org/install.sh | bash
}

function st_rc() {
    if hash nvim &>/dev/null; then
        alias vi=nvim
        alias vim=nvim

    elif hash vim &>/dev/null; then
        alias vi=vim
    fi
}
