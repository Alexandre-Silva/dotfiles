#!/usr/bin/env bash
# ~/.common_shell_vars variables for all shells (bash and zsh)

# Set colour related env vars
if [ "${TERM}" != "linux" ]; then
    if [ -z "$TMUX" ]; then
        if [ -e /usr/share/terminfo/x/xterm+256color ]; then
            export TERM='xterm-256color'
        else
            export TERM='xterm-color'
        fi
    fi

	# Base16 Shell
	export BASE16_SHELL="$DOTFILES/shell/lib/base16-shell"
  theme="$BASE16_SHELL/scripts/base16-bright.sh"
	[[ -s $theme ]] && source "$theme"
fi

# dircolors sets the outputed of ls and such programs, in a more clear colour.
d=$DOTFILES"/shell/dircolors"
[ -f "$d" ] && eval "$(dircolors "$d")" || echo "$d does not exist"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe.sh ] && eval "$(SHELL=/bin/sh lesspipe.sh)"

PATH="$(python -m site --user-base)/bin:${PATH}"
