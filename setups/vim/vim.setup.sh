#!/usr/bin/bash

packages=(
    "pm:neovim"
    "pm:python-neovim"
)

links=(
    # $DOTFILES"/setups/vim/vimrc" $HOME"/.vimrc"
    # $DOTFILES"/setups/vim/gvimrc" $HOME"/.gvimrc"

    # $HOME/{.vimrc,.config/nvim/init.vim}
    # $HOME/{.gvimrc,.ngvimrc}

    "${ADM_DIR}/init.vim" $HOME"/.config/nvim/init.vim"
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
