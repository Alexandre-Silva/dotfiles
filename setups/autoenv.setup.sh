#!/usr/bin/env bash


function st_install() {
    mkdir -vp ~/.config/shell
    curl -L https://raw.githubusercontent.com/Tarrasch/zsh-autoenv/master/autoenv.zsh > ~/.config/shell/autoenv.zsh
}

function st_rc() {
    [ -f ~/.config/shell/autoenv.zsh ] && source ~/.config/shell/autoenv.zsh

    # see https://github.com/Tarrasch/zsh-autoenv#configuration
    # export AUTOENV_FILE_ENTER
    # export AUTOENV_FILE_LEAVE
    # export AUTOENV_LOOK_UPWARDS
    # export AUTOENV_HANDLE_LEAVE
    # export AUTOENV_DISABLED
    # export AUTOENV_DEBUG
}
