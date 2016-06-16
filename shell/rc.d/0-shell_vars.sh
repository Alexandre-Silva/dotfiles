# ~/.common_shell_vars variables for all shells (bash and zsh)

# Set colour related env vars
if [ $TERM != "linux" ]; then
    if [ -z "$TMUX" ]; then
        if [ -e /usr/share/terminfo/x/xterm+256color ]; then
            export TERM='xterm-256color'
        else
            export TERM='xterm-color'
        fi
    fi

	# Base16 Shell
	BASE16_SHELL="$DOTFILES/shell/lib/base16-shell/base16-bright.dark.sh"
	[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
fi

# dircolors sets the outputed of ls and such programs, in a more clear colour.
d=$DOTFILES"/shell/dircolors"
[ -f "$d" ] && eval `dircolors $d` || echo "$d does not exist"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe.sh ] && eval "$(SHELL=/bin/sh lesspipe.sh)"
