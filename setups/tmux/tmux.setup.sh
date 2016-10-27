packages=(
    "pm:tmux"
)

links=(
    {"$DOTFILES/setups/tmux/",~"/."}tmux.conf
    {"$DOTFILES/setups/tmux",~"/.bin"}/tlist-keys.sh
)

function st_install() { return 0; }

function st_profile() { return 0; }

function st_rc() { return 0;}
