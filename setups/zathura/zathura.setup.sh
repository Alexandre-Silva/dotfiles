[[ -n "$ZSH_VERSION" ]] && emulate zsh

packages=(
    "pm:zathura"
    "pm:zathura-pdf-poppler"
)

links=(
    {"$DOTFILES/setups/",~"/.config/"}zathura
)

[[ -n "$ZSH_VERSION" ]] && emulate bash
