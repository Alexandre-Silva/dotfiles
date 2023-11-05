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

# ls/exa, the common ones I use a lot shortened for rapid fire usage
if hash eza &>/dev/null; then
  alias ls='eza'
  alias l='eza -lFh'     #size,show type,human readable
  alias la='eza -lAFh'   #long list,show almost all,show type,human readable
  alias lr='eza -tRFh'   #sorted by date,recursive,show type,human readable
  alias lt='eza -ltFh'   #long list,sorted by date,show type,human readable
  alias ll='eza --long --header --git --sort=name --group-directories-first' #long list
  alias ldot='eza -ld .*'
  alias lS='eza -1FSsh'
  alias lart='eza -1Fcart'
  alias lrt='eza -1Fcrt'

else
  alias l='ls -lFh'     #size,show type,human readable
  alias la='ls -lAFh'   #long list,show almost all,show type,human readable
  alias lr='ls -tRFh'   #sorted by date,recursive,show type,human readable
  alias lt='ls -ltFh'   #long list,sorted by date,show type,human readable
  alias ll='ls -l'      #long list
  alias ldot='ls -ld .*'
  alias lS='ls -1FSsh'
  alias lart='ls -1Fcart'
  alias lrt='ls -1Fcrt'

fi


if hash btop &>/dev/null; then
  alias htop=btop
fi

alias grep='grep --color'
alias sgrep='grep -R -n -H -C 5 --exclude-dir={.git,.svn,CVS} '

alias t='tail -f'

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

alias md='mkdir -p'
alias rd=rmdir

alias zshrc='$EDITOR ~/.zshrc' # Quick access to the ~/.zshrc file

#alias kinit="secret-tool lookup ist pass | kinit $(secret-tool lookup ist user) > /dev/null"
alias kinit-ist="kinit ist173968@IST.UTL.PT"

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias slFE="while true; do sl;done"

if which viddy &>/dev/null; then
  alias watch="viddy"
fi

#trash-cli
alias tp=trash-put
alias th-put=trash-put
alias th-list=trash-list
alias th-trash=restore-trash
alias th-empty=trash-empty
hash trash &>/dev/null && alias rm='trash-put'

# Misc servers
alias server.http='python -m http.server'
alias server.ftp='python -m pyftpdlib -w'
alias server.vnc='x11vnc -forever -nopw -display $DISPLAY'

# Info & Status
alias ipinfo='curl ipinfo.io --no-progress-meter | jq "del(.readme)"'

alias kb='kbd_setup.sh'

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


alias ip="ip --color"

if hash bat &>/dev/null; then alias cat='bat -pp'; fi

if hash gping &>/dev/null;
  then alias ping='gping';
elif hash prettyping &>/dev/null;
  then alias ping='prettyping --nolegend';
fi

# du - disk usage; see functions.sh for du-usage
if hash duf &>/dev/null; then
  alias df='duf'
fi

if hash duf &>/dev/null; then
  alias du="ncdu --color dark -rr -x --exclude .git --exclude node_modules";
  alias duf='/usr/bin/du -sh *'
  alias dud='/usrc/bin/du -d 1 -h'
else
  alias du="du --human-readable"
  alias duf='du -sh *'
  alias dud='du -d 1 -h'
fi

if hash dog &>/dev/null; then alias dig='dog'; fi

################################################################################
### Arch
### based on: https://github.com/robbyrussell/oh-my-zsh/tree/master/plugins/archlinux
################################################################################
if hash pacman &>/dev/null; then
    PACMAN='sudo pacman'

    if hash pikaur &>/dev/null; then
        PACMAN=pikaur
    fi

    alias pacfileupg="$PACMAN -F --refresh"
    alias pacfile="pkgfile"
    alias pacin="$PACMAN -S"
    alias pacins="$PACMAN -U"
    alias pacinsd="$PACMAN -S --asdeps"
    alias pacloc="$PACMAN -Q --info"
    alias paclocs="$PACMAN -Q --search"
    alias paclst="$PACMAN -Q --explicit"
    alias pacmir="$PACMAN -Syy"
    alias pacorph="$PACMAN -Q --unrequired --deps"
    alias pacre="$PACMAN -R"
    alias pacrem="$PACMAN -R --unneeded --recursive"
    alias pacrep="$PACMAN -S --info"
    alias pacreps="$PACMAN -S --search"
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

alias grub-update='grub-mkconfig -o /boot/grub/grub.cfg'
