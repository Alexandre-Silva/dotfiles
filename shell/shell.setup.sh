#!/bin/bash

packages=(
    "pm:zsh"
    "pm:zsh-completions"
    "pm:zsh-doc"
)


links=()

for f in profile bashrc zprofile zshrc; do
    links+=( {"$DOTFILES/shell/",~/.}"$f" )
done


st_install() {
    "$DOTFILES/bin/sh/install-oh-my-zsh"
}
