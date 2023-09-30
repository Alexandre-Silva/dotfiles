#!/bin/bash

packages=(
    "pm:bash"
    "pm:bash-completion"

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
    "pm:fzf" # A command-line fuzzy finder. https://github.com/junegunn/fzf
    "pm:entr"  # executed cmd on file changes
    "pm:fasd"  # Fasd offers quick access to files and directories for POSIX shells.
    "pm:starship" # The minimal, blazing-fast, and infinitely customizable prompt for any shell!
    # "pm:ttf-nerd-fonts-symbols-mono" # for starship icons
    "pm:sd" # sd is an intuitive find & replace CLI.
    "pm:ripgrep" # better grep
    "pm:eza" # better ls
    "pm:duf" # better du
    "aur:viddy" # better watch command
)


links=(
    "$DOTFILES/shell/lib/mo/mo" $HOME/.bin/mo
    "$DOTFILES/shell/lib/mo/mo" $HOME/.bin/mo

    {"$DOTFILES/shell/",${XDG_CONFIG_HOME:-$HOME/.config}/}starship.toml
)

depends=("$DOTFILES/setups/oh-my-zsh/setup.sh")

for f in profile bashrc zprofile zshrc; do
    links+=( {"$DOTFILES/shell/",$HOME/.}"$f" )
done
