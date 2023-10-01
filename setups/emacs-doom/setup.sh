#!/bin/zsh

packages=(
    "pm:emacs-nativecomp"
)

links=(
    #"$DOTFILES/setups/emacs-doom/" "$HOME/.doom.d"
    "$DOTFILES/setups/emacs-doom/" "$HOME/.config/doom"
)

function st_install() {
  echo 'follow doom emacs docs'
}

st_profile() {
    if [[ -d "$HOME/.config/emacs/bin" ]]; then export PATH="$PATH:$HOME/.config/emacs/bin"
    elif [[ -d "$HOME/.emacs.d/bin" ]];    then export PATH="$PATH:$HOME/.emacs.d/bin"
    fi
}
