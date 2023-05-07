#!/usr/bin/bash

links=()

if [ -n "$ZSH" ] && [ -d "${ZSH}" ] || [ -d "$HOME/.oh-my-zsh" ]; then
    if [ ! -d "${ZSH}" ]; then
        export ZSH="$HOME/.oh-my-zsh"
    fi


    for plugin in "$DOTFILES/setups/oh-my-zsh/plugins/"*; do
        links+=( "$plugin" "$ZSH/custom/plugins/$(basename $plugin)" )
    done

    for theme in "$ADM_DIR/themes/"*; do
        links+=( "$theme" "$ZSH/custom/themes/$(basename $theme)" )
    done
fi

st_install() {
    if [ -n "$ZSH" ] && [ -d "${ZSH}" ]; then
        echo "Oh-my-zsh already installed."
        . "$ZSH/tools/upgrade.sh"

    elif [ ! -e $HOME/.oh-my-zsh ]; then
        echo "Cloning oh-my-zsh."
        git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
        export ZSH="$HOME/.oh-my-zsh"
        echo "Oh-my-zsh is ready to use."

    else
        echo "$HOME/.oh-my-zsh already exists skipping install of oh-my-zsh"

    fi
}
