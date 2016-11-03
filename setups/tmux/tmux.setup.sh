packages=(
    "pm:tmux"
)

links=(
    {"$DOTFILES/setups/tmux/",$HOME"/."}tmux.conf
    {"$DOTFILES/setups/tmux",$HOME"/.bin"}/tlist-keys.sh
)

function st_install() { return 0; }

function st_profile() { return 0; }

function st_rc() { return 0;}
