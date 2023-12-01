#!/bin/bash

################################################################################
### User
################################################################################

# given a pdf returns the number for pages
pdfinfo-pages() {
    pdfinfo "$@" | grep Pages | awk '{print $2}'
}

pdfgrep.xargs() {
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
inotifyexec() {
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

mkcd() {
    mkdir --parents "$@" && cd "$@"
}

l33t() {
    while [[ "$is_done" -eq 0 ]]; do
        local is_done=0
        if [[ "$#" == 0 ]]; then
            local read_arr_flg=''
            [[ -n "$ZSH_VERSION" ]] && read_arr_flg='-A';
            [[ -n "$BASH_VERSION" ]] && read_arr_flg='-a';

            if read -r "${read_arr_flg}" words; then
                echo done
                is_done=1
            else
                echo not done
            fi
        else
            local words=("$@")
            is_done=1
        fi

        local words_leet=()
        for word in "${words[@]}"; do
            word="$(echo $word | sed "s/ed$/d/")"

            word="$(echo $word | sed "s/s$/z/")"
            word="$(echo $word | sed "s/cks/x/g;s/cke/x/g")"
            word="$(echo $word | sed "s/a/@/g;s/e/3/g;s/o/0/g")"
            word="$(echo $word | sed "s/^@/a/")"
            word="$(echo $word |  tr "[[:lower:]]" "[[:upper:]]")"

            words_leet+=( "$word" )
        done

        echo "${words_leet[@]}"
    done
}

# see https://cli.fyi/
fyi() {
    curl cli.fyi/"$1"
}

ssh-cam() {
    local host="$1"
    local video="${2:-/dev/video0}"

    ssh "$host" ffmpeg -an -f video4linux2 -s 640x480 -i /dev/video0 -r 10 -b:v 500k -f matroska - | mpv --demuxer=mkv /dev/stdin
}


################################################################################
### System
################################################################################

du-usage() {
  /usr/bin/du -s "$@" 2>/dev/null | awk '{ print $1 }'
}
du-usageh() {
  /usr/bin/du -sh "$@" 2>/dev/null | awk '{ print $1 }'
}

# Get current host related info.
ii() {
    &>/dev/null hash grc && local g=grc

    echo -e "\nYou are logged on ${BRed}$(hostname)"
    echo -e "\n${BRed}Additionnal information:$Color_Off " ; uname -a
    echo -e "\n${BRed}Users logged on:$Color_Off " ; w -hs | cut -d " " -f1 | sort | uniq
    echo -e "\n${BRed}Current date :$Color_Off " ; date
    echo -e "\n${BRed}Machine stats :$Color_Off " ; uptime
    echo -e "\n${BRed}Memory stats :$Color_Off " ; free -h
    echo -e "\n${BRed}Diskspace :$Color_Off " ; $g df -h / $HOME
    echo -e "\n${BRed}WAN IP Address :$Color_Off" ; dig +short myip.opendns.com @resolver1.opendns.com
    echo -e "\n${BRed}Open connections :$Color_Off "; $g netstat -np46l 2>/dev/null;
    echo
}
