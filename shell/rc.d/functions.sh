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
