#!/usr/bin/env bash

# see https://mrzool.cc/writing/sensible-bash/

bind "set completion-ignore-case on"
bind "set completion-map-case on"
bind "set show-all-if-ambiguous on"

shopt -s autocd   # enter dir name in shell and bash understands and prepends cd
shopt -s dirspell # autocorrect minor spelling errors
shopt -s cdspell  # autocorrect minor spelling errors


# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi
