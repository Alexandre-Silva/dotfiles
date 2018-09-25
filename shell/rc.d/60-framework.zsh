#!/usr/bin/bash

FRAMEWORK=oh-my-zsh
case "${FRAMEWORK}" in
    prezto)
        rc="${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
        [ -f "${rc}" ] && source "${rc}"
        ;;

    oh-my-zsh)
        rc="${DOTFILES}/shell/oh-my-zshrc"
        [ -d "$HOME/.oh-my-zsh" ] && [ -f "${rc}" ] && source "${rc}"
        ;;
esac
unset rc
