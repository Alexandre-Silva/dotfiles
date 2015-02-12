#!/bin/zsh

# Only for login shells.
[[ -o login ]] || exit 0

# Same behaviour as bash.
emulate sh 
. /etc/profile
. ~/.profile
emulate zsh
