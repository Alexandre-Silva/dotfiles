packages=(
    "pm:git"
)

links=(
    {"$DOTFILES/setups/git/",$HOME/.}gitconfig
    {"$DOTFILES/setups/git/",$HOME/.}gitignore_global
)

st_profile() {
    export GIT_EDITOR="et"
}
