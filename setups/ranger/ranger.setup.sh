# misc configs for ranger file manager
# refs:
#   /usr/share/doc/ranger/examples/bash_automatic_cd.sh

packages=(
    "pm:ranger"

    # Extras
    "pm:libcaca"
    "pm:highlight"
    "pm:atool"
    "pm:poppler"
    "pm:mediainfo"
)

links=(
    {"$DOTFILES/setups/ranger/config",~"/.config/ranger"}
    {"$DOTFILES/setups/ranger/",~"/.bin/"}rangerl
)

function st_rc() {

    # Automatically change the directory in bash after closing ranger
    #
    # This is a bash function for .bashrc to automatically change the directory to
    # the last visited one after ranger quits.
    # To undo the effect of this function, you can type "cd -" to return to the
    # original directory.
    function ranger-cd {
        local opts=""

        if [ -n "$XDG_RUNTIME_DIR" ]; then
            [ -d "$XDG_RUNTIME_DIR/ranger" ] || mkdir "$XDG_RUNTIME_DIR/ranger"
            opts="--tmpdir=$XDG_RUNTIME_DIR/ranger"
        fi

        tempfile="$(mktemp $opts -t last-dir.XXXXXX)"
        /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
        test -f "$tempfile" &&
            if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
                cd -- "$(cat "$tempfile")"
            fi
        rm -f -- "$tempfile"
    }

    function ranger {
        # Start new ranger instance only if it's not running in current shell
        [ -n "$RANGER_LEVEL" ] && exit
        ranger-cd "$@"
    }

    alias rg=ranger
    alias rgl=rangerl # script for gui launcher (e.g. awesome)
}
