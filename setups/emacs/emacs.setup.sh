#!/bin/zsh

packages=(
    "pm:emacs"
    "pm:aspell"{,-en,-pt}
)

links=(
    {"$DOTFILES/setups/emacs/",~"/."}spacemacs
    {"$DOTFILES/setups/emacs/",~"/.bin/"}ec
    {"$DOTFILES/setups/emacs/",~"/.bin/"}et
    {"$DOTFILES/setups/emacs/",~"/.bin/"}es
)

function st_install() {
    if [[ -d "$HOME/.emacs.d/" ]]; then
        echo "Updating Spacemacs"
        git -C "$HOME/.emacs.d" pull

    else
        "Cloning Spacemacs"
        git clone ssh://git@github.com/syl20bnr/spacemacs "$HOME/.emacs.d"
    fi
}
