#!/bin/bash - 
#
# misc configs for ranger file manager
# refs:
#   /usr/share/doc/ranger/examples/bash_automatic_cd.sh

# Automatically change the directory in bash after closing ranger
#
# This is a bash function for .bashrc to automatically change the directory to
# the last visited one after ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.

function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXX)"
    /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

# This binds Ctrl-O to ranger-cd:
[ -n "$BASH_VERSION" ] && bind '"\C-o":"ranger-cd\C-m"'
[ -n "$ZSH_VERSION" ] && bindkey -s '^o' '^Uranger-cd^M'
