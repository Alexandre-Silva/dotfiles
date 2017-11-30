#!/bin/bash

################################################################################
### User
################################################################################
function alex-init () {
    local progs=(
        thunderbird
        firefox
        keepassxc
        canto-cursesl
    )

    for p in "${progs[@]}"; do
        echo $p
        $p &>>"$HOME/.log/$p.log" & disown
    done
}

function alex-nvidia-config {
    local offset="$1"
    nvidia-settings --assign "[gpu:0]/GPUGraphicsClockOffset[2]=${offset}"
    nvidia-settings --assign "[gpu:0]/GPUMemoryTransferRateOffset[2]=$(( offset * 2 ))"
}

# show files whenever entering a dir
function cd { builtin cd "$@" && ls; }


function pdfgrep.xargs () {
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


# When a change to the monitored files is detected the command passed as argument is executed
# Example: inotifyexec ./foo.txt -- cat ./foo.txt
# Depreacated in favor of entr
function inotifyexec() {
    echo "Use entr instead!!!"
    exit 1
}


fuck() {
    if [ "$UID" -eq 0 ]; then
        eval "$(fc -ln -1)"
    elif hash sudo && groups | egrep -q "\<(sudo|wheel)\>"; then
        sudo "$(fc -ln -1)"
    else
        su -c "$(fc -ln -1)" root
    fi
}

################################################################################
### System
################################################################################

# Get current host related info.
function ii(){
    &>/dev/null hash grc && local g=grc

    echo -e "\nYou are logged on ${BRed}$(hostname)"
    echo -e "\n${BRed}Additionnal information:$Color_Off " ; uname -a
    echo -e "\n${BRed}Users logged on:$Color_Off " ; w -hs |
        cut -d " " -f1 | sort | uniq
    echo -e "\n${BRed}Current date :$Color_Off " ; date
    echo -e "\n${BRed}Machine stats :$Color_Off " ; uptime
    echo -e "\n${BRed}Memory stats :$Color_Off " ; free -h
    echo -e "\n${BRed}Diskspace :$Color_Off " ; $g df -h / $HOME
    echo -e "\n${BRed}WAN IP Address :$Color_Off" ; dig +short myip.opendns.com @resolver1.opendns.com
    echo -e "\n${BRed}Open connections :$Color_Off "; $g netstat -np46l 2>/dev/null;
    echo
}
