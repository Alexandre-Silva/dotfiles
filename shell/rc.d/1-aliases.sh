#!/usr/bin/env bash
# ~/.common_aliases common for all shells (such as bash and zsh)

alias vimrc="vim ~/.vimrc"

alias tt=todo.sh

#alias kinit="secret-tool lookup ist pass | kinit $(secret-tool lookup ist user) > /dev/null"
alias kinit-ist="kinit ist173968@IST.UTL.PT"

# the extra space allows for defined aliases to be transfered to other users env
alias sudo="sudo "

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias slFE="while true; do sl;done"
alias fuck='sudo !!'


### ps ###
PS_FORMAT="pid,ppid,tty,rtprio,stat,pcpu,pmem,comm"

alias psm="ps -u $(whoami) -o $PS_FORMAT"
alias psa="ps -eo $PS_FORMAT"
alias pm="ps -fu $(whoami) "
alias pa="p -fe"

unset	PS_FORMAT

### Raspberry-pi related alias ###
alias tunnel.pi_nas='ssh -L 10445:localhost:445 -f -C -N pi &'

### TMUX ###
alias t-n="tmux new"
alias t-a="tmux attach"
alias t-l="tmux ls"

#trash-cli
alias tsp=trash-put
alias tsl=trash-list
alias tsr=restore-trash
alias tse=trash-empty

# enable color support of ls and also add handy aliases
if  hash dircolors &>/dev/null; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi
