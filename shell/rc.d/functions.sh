#!/bin/bash
# misc funcs for nothing and everything

# Initial startup script, kills xfce-panel 
# and inits firefoz thunderbird ....
#
function alex-init () {
    pkill xfce4-panel 

    sleep 0.2
    echo 'customization.orig.restart()' | awesome-client

    thunderbird &>>"$HOME/.log/thunderbird.log" & disown
    firefox &>>"$HOME/.log/firefox.log" & disown
    skype &>>"$HOME/.log/skype.log" & disown
    syncthing &>>"$HOME/.log/syncthing.log" & disown
    pnmixer &>>"$HOME/.log/pnmixer.log" & disown

    pkill xfsettingsd && xfsettingsd
    #(  sleep 10 && kinit  ) & disown  
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