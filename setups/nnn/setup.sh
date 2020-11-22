#!/usr/bin/env bash

packages=(
    'pm:nnn'
)

links=( "${ADM_DIR}" "${XDG_CONFIG_HOME:-$HOME/.config}/nnn/" )

st_install() {
    curl -Ls https://raw.githubusercontent.com/jarun/nnn/master/plugins/getplugs | sh
}

st_rc() {
    lastcd='/usr/share/nnn/quitcd/quitcd.bash_zsh'
    [ -f "${lastcd}" ] && source "${lastcd}"
}
