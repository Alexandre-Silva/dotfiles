#!/usr/bin/env bash

# dotfiles/shell/rc
# loads all files in dotfiles/shell/rc.d

[ -z $DOTFILES ] && printf "dotfiles/shell/rc\nvar DOTFILES is not defined" && return 1

# load all posis compatible files
for f in $DOTFILES"/shell/rc.d/"* ; do
    case $f in
        *.zsh)  [[ -n ${ZSH_VERSION} ]]  && source "${f}" ;;
        *.bash) [[ -n ${BASH_VERSION} ]] && source "${f}" ;;
        *.sh)                               source "${f}" ;;
        *) echo -2 "Invalid extension for file:$f"        ;;
    esac
done
