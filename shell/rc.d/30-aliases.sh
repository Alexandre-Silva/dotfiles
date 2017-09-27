#!/usr/bin/env bash

################################################################################
### User
################################################################################

# enable color support of ls and also add handy aliases
if  hash dircolors &>/dev/null; then
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ls, the common ones I use a lot shortened for rapid fire usage
alias l='ls -lFh'     #size,show type,human readable
alias la='ls -lAFh'   #long list,show almost all,show type,human readable
alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
alias ll='ls -l'      #long list
alias ldot='ls -ld .*'
alias lS='ls -1FSsh'
alias lart='ls -1Fcart'
alias lrt='ls -1Fcrt'

alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'

alias dud='du -d 1 -h'
alias duf='du -sh *'
alias fd='find . -type d -name'
alias ff='find . -type f -name'

alias h='history'
alias hgrep="fc -El 0 | grep"
alias help='man'
alias p='ps -f'
alias sortnr='sort -n -r'
alias unexport='unset'

alias whereami=display_info

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

alias zshrc='$EDITOR ~/.zshrc' # Quick access to the ~/.zshrc file

#alias kinit="secret-tool lookup ist pass | kinit $(secret-tool lookup ist user) > /dev/null"
alias kinit-ist="kinit ist173968@IST.UTL.PT"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias slFE="while true; do sl;done"

#trash-cli
alias tp=trash-put
alias th-put=trash-put
alias th-list=trash-list
alias th-trash=restore-trash
alias th-empty=trash-empty

# Misc servers
alias server.http='python3 -m http.server'
alias server.ftp='python3 -m pyftpdlib -w'
alias server.vnc='x11vnc -forever -nopw -display $DISPLAY'

################################################################################
### System
################################################################################

alias lsblk='lsblk -o name,model,fstype,size,label,uuid,mountpoint'

# the extra space allows for defined aliases to be transfered to other users env
alias sudo="sudo "

### ps ###
PS_FORMAT="pid,ppid,tty,rtprio,stat,pcpu,pmem,comm"

alias psm="ps -u $(whoami) -o $PS_FORMAT"
alias psa="ps -eo $PS_FORMAT"
alias pm="ps -fu $(whoami) "
alias pa="p -fe"

unset	PS_FORMAT

# du - disk usage
alias du="du --human-readable"

alias ip="ip --color"

################################################################################
### Arch
### based on: https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/archlinux
################################################################################
if hash pacman &>/dev/null; then
    PACMAN='sudo pacman'

    if hash pacaur &>/dev/null; then
        PACMAN=pacaur
    fi

    alias pacfileupg="$PACMAN -Fy"
    alias pacin="$PACMAN -S"
    alias pacins="$PACMAN -U"
    alias pacinsd="$PACMAN -S --asdeps"
    alias pacloc="$PACMAN -Qi"
    alias paclocs="$PACMAN -Qs"
    alias paclst="$PACMAN -Qe"
    alias pacmir="$PACMAN -Syy"
    alias pacorph="$PACMAN -Qtd"
    alias pacre="$PACMAN -R"
    alias pacrem="$PACMAN -Rns"
    alias pacrep="$PACMAN -Si"
    alias pacreps="$PACMAN -Ss"
    alias pacrmorphans="$PACMAN"' -Rs $(pacman -Qtdq)'
    alias pacsu="$PACMAN -Syua --noconfirm"
    alias pacupd="$PACMAN -Sy"
    alias pacupg="$PACMAN -Syu"

    paclist() {
        # Source: https://bbs.archlinux.org/viewtopic.php?id=93683
        LC_ALL=C pacman -Qei $(pacman -Qu | cut -d " " -f 1) | \
            awk 'BEGIN {FS=":"} /^Name/{printf("\033[1;36m%s\033[1;37m", $2)} /^Description/{print $2}'
    }

    pacdisowned() {
        tmp=${TMPDIR-/tmp}/pacman-disowned-$UID-$$
        db=$tmp/db
        fs=$tmp/fs

        mkdir "$tmp"
        trap  'rm -rf "$tmp"' EXIT

        pacman -Qlq | sort -u > "$db"

        find /bin /etc /lib /sbin /usr ! -name lost+found \
             \( -type d -printf '%p/\n' -o -print \) | sort > "$fs"

        comm -23 "$fs" "$db"
    }

    pacmanallkeys() {
        curl -s https://www.archlinux.org/people/{developers,trustedusers}/ | \
            awk -F\" '(/pgp.mit.edu/) { sub(/.*search=0x/,""); print $1}' | \
            xargs sudo pacman-key --recv-keys
    }

    pacmansignkeys() {
        for key in $*; do
            sudo pacman-key --recv-keys $key
            sudo pacman-key --lsign-key $key
            printf 'trust\n3\n' | sudo gpg --homedir /etc/pacman.d/gnupg \
                                       --no-permission-warning --command-fd 0 --edit-key $key
        done
    }

    unset PACMAN
fi
