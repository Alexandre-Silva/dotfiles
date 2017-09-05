#!/bin/zsh

FRAMEWORK=oh-my-zsh
case "${FRAMEWORK}" in
    prezto)
        local rc="${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
        [ -f "${rc}" ] && source "${rc}"
        ;;

    oh-my-zsh)
        local rc="${DOTFILES}/shell/oh-my-zshrc"
        [ -f "${rc}" ] && source "${rc}"
        ;;
esac
