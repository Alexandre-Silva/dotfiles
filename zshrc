#!/bin/zsh

# Only for interactive shells.
[[ -o interactive ]] || exit 0


FRAMEWORK=oh-my-zsh
if [ $FRAMEWORK = prezto ];then

    # Source Prezto.
    if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
        source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
    fi

elif [ $FRAMEWORK = oh-my-zsh ];then

    # Source oh-my-zsh
    if [ -r $HOME/.oh-my-zshrc ];then
        source $HOME/.oh-my-zshrc
    fi
fi


# Add help command
autoload -U run-help
autoload run-help-git
autoload run-help-svn
autoload run-help-svk
alias help=run-help

# zsh options
setopt AUTO_CD EXTENDED_GLOB RM_STAR_WAIT

# ctrl-u does the same it did in bash.
bindkey \^U backward-kill-line

# common and misc aliases
if [ -f ~/.common_aliases ]; then
    source ~/.common_aliases
fi

# Functions definitions.
if [ -f ~/.common_funcs ]; then
    . ~/.common_funcs
fi


# shell specific vars definitions.
if [ -f ~/.common_shell_vars ]; then
    . ~/.common_shell_vars
fi

# Machine local confs
if [ -f ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi
