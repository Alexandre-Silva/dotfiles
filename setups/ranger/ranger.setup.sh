[[ -n "$ZSH_VERSION" ]] && emulate zsh

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
    {"$DOTFILES/setups/",~"/.config/"}ranger
)


[[ -n "$ZSH_VERSION" ]] && emulate bash
