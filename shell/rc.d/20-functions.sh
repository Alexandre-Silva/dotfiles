#!/bin/bash

################################################################################
### User
################################################################################
function alex-init () {
    progs=( thunderbird firefox keepassx2 canto-cursesl )

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

function alex-desktop-init () {
    sleep 5

    local progs=(
        firefox
        canto-cursesl
        ec
        nvidia-fan-curve.sh
	      discord-canary
    )

    for p in "${progs[@]}"; do
        echo "$p"
        $p &>>"$HOME/.log/$p.log" & disown
    done

    alex-nvidia-config -130
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


### Raspberry-pi related funcs ###

function mount.pi_music () {
    local target=pi@soulcasa.ddns.net:/media/HDD1/share/music/
    local mntPoint=/mnt/pi_music

    out=$(mountpoint $mntPoint 2>&1)
    if [ $? -eq 0 ]; then
        echo $out
        return
    else
        if [[ $out != $mntPoint" is not a mountpoint" ]] ; then
            echo $out
            echo "try: pkill sshfs; sudo umount -l /mnt"
            return
        fi
    fi

    echo "mounting..."
    #sshfs -o allow_other -o reconnect -o ServerAliveInterval=15 pi@soulcasa.ddns.net:/media/HDD1/share/music/  -p 2222 -o IdentityFile=$HOME"/.ssh/id_rsa"
    sudo sshfs \
         -o allow_other -o reconnect -o ServerAliveInterval=15 \
         -p 2222 -o IdentityFile=$HOME"/.ssh/id_rsa" -C \
         $target $mntPoint

    if [ $? -eq 0 ]; then
        echo "Success"
    else
        echo "Failure: " $?
    fi
}


################################################################################
### System
################################################################################

# Get current host related info.
function ii(){
    &>/dev/null hash grc && local g=grc

    echo -e "\nYou are logged on ${BRed}$(hostname)"
    echo -e "\n${BRed}Additionnal information:$NC " ; uname -a
    echo -e "\n${BRed}Users logged on:$NC " ; w -hs |
        cut -d " " -f1 | sort | uniq
    echo -e "\n${BRed}Current date :$NC " ; date
    echo -e "\n${BRed}Machine stats :$NC " ; uptime
    echo -e "\n${BRed}Memory stats :$NC " ; free -h
    echo -e "\n${BRed}Diskspace :$NC " ; $g df -h / $HOME
    echo -e "\n${BRed}WAN IP Address :$NC" ; dig +short myip.opendns.com @resolver1.opendns.com
    echo -e "\n${BRed}Open connections :$NC "; $g netstat -np46l 2>/dev/null;
    echo
}
