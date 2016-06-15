[[ -n "$ZSH_VERSION" ]] && emulate zsh

packages=(
    "pm:xdg-user-dirs"
    "pm:xdg-utils"
)

links=(
    {"$DOTFILES/setups/xdg/",~"/.config/"}user-dirs.dirs
)

[[ -n "$ZSH_VERSION" ]] && emulate bash
