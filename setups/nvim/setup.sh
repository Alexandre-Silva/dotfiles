#!/usr/bin/bash

packages=(
    "pm:neovim"
    "pm:python-neovim"
)

links=(
)

# function st_install() { nvim -c "PluginUpdate" -c "quitall" ; }

function st_rc() {
    alias vimrc="nvim $HOME/.config/nvim/init.vim"

    if hash nvim &>/dev/null; then
        alias vi=nvim
        alias vim=nvim

    elif hash vim &>/dev/null; then
        alias vi=vim
    fi
}
