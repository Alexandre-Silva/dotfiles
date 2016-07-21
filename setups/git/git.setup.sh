packages=(
    "pm:git"
)

links=(
    {"$DOTFILES/setups/git/",~/.}gitconfig
    {"$DOTFILES/setups/git/",~/.}gitignore_global
)

st_profile() {
    export GIT_EDITOR="et"
}
