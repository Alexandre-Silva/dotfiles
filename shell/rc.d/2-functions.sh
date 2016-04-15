#!/bin/bash
# misc funcs for nothing and everything

# Initial startup script, kills xfce-panel
# and inits firefoz thunderbird ....
#
function alex-init () {
    progs=( thunderbird firefox skype keepass )

    for p in ${progs[@]}; do
        echo $p
        $p &>>"$HOME/.log/$p.log" & disown
    done
}


# show files whenever entering a dir
function cd { builtin cd "$@" && ls; }


# verifies if $1 existe in array on $2
# in python it would be if $1 in $2; something
containsElement ()
{
    local e
    for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
    return 1
}


function pdfgrep-xargs () {
    local args=("$@")

    if [ ${#args} -ne 2 ] ; then
        printf "usage pdfgrep-xargs <find starting point> <grep string>"
        return
    fi

    local startingPoint=${args[1]}
    local grepStr=${args[2]}

    find "$startingPoint" -iname "*.pdf" -print0 | xargs --null -L 1 --max-procs=4 pdfgrep -Hn "$grepStr"
}


# pretty man
man() {
    env LESS_TERMCAP_mb=$'\E[01;31m' \
        LESS_TERMCAP_md=$'\E[01;38;5;74m' \
        LESS_TERMCAP_me=$'\E[0m' \
        LESS_TERMCAP_se=$'\E[0m' \
        LESS_TERMCAP_so=$'\E[0;30;47m' \
        LESS_TERMCAP_ue=$'\E[0m' \
        LESS_TERMCAP_us=$'\E[04;38;5;146m' \
        man "$@"
}
