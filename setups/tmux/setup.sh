packages=(
    "pm:tmux"
)

links=(
    {"$DOTFILES/setups/tmux/",$HOME"/."}tmux.conf
    {"$DOTFILES/setups/tmux",$HOME"/.bin"}/tlist-keys.sh
)

st_rc() {
    alias t-n="tmux new"
    alias t-a="tmux attach"
    alias t-l="tmux ls"
}
