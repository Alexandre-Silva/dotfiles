packages=(
    "pm:neovim"
    "pm:python-neovim"
)

links=(
    "$ADM_DIR"/ $HOME/.SpaceVim.d
)

function st_install() {
    curl -sLf https://spacevim.org/install.sh | bash
}

