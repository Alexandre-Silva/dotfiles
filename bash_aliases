if [ -f ~/.bash_aliases_colors ]; then
    . ~/.bash_aliases_colors
fi


if [ -f ~/.common_aliases ]; then
    . ~/.common_aliases
fi

### alias variados  ###
##  alias ls="ls -lhF --color=auto"
alias s=sudo
alias sagi="sudo apt-get install"
alias acs="apt-cache search"
alias auu="sudo apt-get update && sudo apt-get upgrade"

### ls ###
# some more ls aliases
alias ll='ls -lhF'
alias lla='ls -alhF'
alias la='ls -A'
alias l='ls -CF'

### ps ###
PS_FORMAT="pid,ppid,tty,rtprio,stat,pcpu,pmem,comm"

alias psm="ps -u $(whoami) -o $PS_FORMAT"
alias psa="ps -eo $PS_FORMAT"

unset	PS_FORMAT

### TMUX ###
alias t-n="tmux new"
alias t-a="tmux attach"
alias t-l="tmux ls"

