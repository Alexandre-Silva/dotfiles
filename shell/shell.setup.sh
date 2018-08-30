#!/bin/bash

packages=(
    "pm:zsh"
    "pm:zsh-completions"
    "pm:zsh-doc"

    # For misc cmds/functions
    "pm:python-pyftpdlib"
    "pm:trash-cli"
    "pm:fd" # better find
    "pm:bat" # cat++
    "pm:prettyping" # better ping
    "pm:ncdu" # better du
    "pm:tldr" # Simplified and community-driven man pages. https://tldr.sh/
    "pm:jq" # jq is a lightweight and flexible command-line JSON processor. https://stedolan.github.io/jq/
    "aur:entr"  # executed cmd on file changes
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
