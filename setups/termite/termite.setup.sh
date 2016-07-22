#!/bin/bash

packages=(
    "pm:termite"
)

links=(
    {"$DOTFILES/setups/",~"/.config/"}termite
)

st_install() {
    local here="$DOTFILES/setups/termite"

    if [[ "$(hostname)" == "alex-desktop" ]]; then
        local font=11
    else
        local font=9
    fi

    FONT_SIZE=$font mo "$here/config.mo" >"$here/config"
}
