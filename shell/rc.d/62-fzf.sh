# configs removed fro mhttps://github.com/junegunn/fzf/wiki/Configuring-shell-key-bindings

export FZF_CTRL_T_OPTS="--preview '(highlight -O ansi -l {} 2> /dev/null || cat {} || tree -C {}) 2> /dev/null | head -200'"
