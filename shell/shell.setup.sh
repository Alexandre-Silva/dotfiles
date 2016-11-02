#!/bin/bash

packages=(
    "pm:zsh"
    "pm:zsh-completions"
    "pm:zsh-doc"
)


links=(
    "$DOTFILES/shell/lib/mo/mo" ~/.bin/mo
)

for f in profile bashrc zprofile zshrc; do
    links+=( {"$DOTFILES/shell/",~/.}"$f" )
done


st_install() {
    "$DOTFILES/bin/sh/install-oh-my-zsh"
}

st_rc() {
    # loads funcs, aliases and shell vars
    rc=$DOTFILES"/shell/rc.sh"
    [ -f "$rc" ] && . "$rc"
}
