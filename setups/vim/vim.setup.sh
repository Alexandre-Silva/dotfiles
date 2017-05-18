#!/usr/bin/bash

packages=(
    "pm:neovim"
)

links=(
    $DOTFILES"/setups/vim/vimrc" $HOME"/.vimrc"
    $DOTFILES"/setups/vim/gvimrc" $HOME"/.gvimrc"

    $HOME/{.vimrc,.config/nvim/init.vim}
    $HOME/{.gvimrc,.ngvimrc}
)

function st_install() { vim -c "PluginUpdate" -c "quitall" ; }

function st_rc() {
    alias vimrc="vim ~/.vimrc"

    if hash nvim &>/dev/null; then
        alias vi=nvim
        alias vim=nvim

    elif hash vim &>/dev/null; then
        alias vi=vim
    fi
}
