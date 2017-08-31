#!/bin/bash

packages=(
    "pm:zsh"
    "pm:zsh-completions"
    "pm:zsh-doc"
    "pm:zsh-syntax-highlighting"

    # For misc cmds/functions
    "pm:python-pyftpdlib"
    "pm:trash-cli"
)


links=(
    "$DOTFILES/shell/lib/mo/mo" $HOME/.bin/mo
)

for f in profile bashrc zprofile zshrc; do
    links+=( {"$DOTFILES/shell/",$HOME/.}"$f" )
done


st_install() {
    "$DOTFILES/bin/sh/install-oh-my-zsh"
}
