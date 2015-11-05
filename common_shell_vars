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
	BASE16_SHELL="$HOME/.config/base16-shell/base16-bright.dark.sh"
	[[ -s $BASE16_SHELL ]] && source $BASE16_SHELL
fi


export DOTFILES="$HOME/dotfiles"

# dircolors sets the outputed of ls and such programs, in a more clear colour.
[ -f "$DOTFILES/dircolors" ] && eval `dircolors $DOTFILES/dircolors`


export TODOTXT_CFG_FILE="$DOTFILES/todo.cfg"
export TODO_ACTIONS_DIR="$DOTFILES/todo.actions.d"

[ -d "$HOME/.nim_install" ] && export PATH="$HOME/.nim_install/bin:$PATH"

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe.sh ] && eval "$(SHELL=/bin/sh lesspipe.sh)"
