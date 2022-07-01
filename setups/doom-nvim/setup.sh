packages=(
    "pm:neovim"
    "pm:python-neovim"
)

links=(
    "$ADM_DIR"/ $HOME/.config/doom-nvim/
    $HOME/.config/doom-nvim/ $HOME/.config/nvim/ 
)

function st_install() {
    git clone --depth 1 https://github.com/NTBBloodbath/doom-nvim.git $HOME/.config/nvim-doom-git
}

