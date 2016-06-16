packages=(
    "pm:zsh"
    "pm:zsh-completions"
    "pm:zsh-doc"
)


links=(
    {"$DOTFILES/shell/",~/.}profile
    {"$DOTFILES/shell/",~/.}bashrc

    {"$DOTFILES/shell/",~/.}zprofile
    {"$DOTFILES/shell/",~/.}zshrc
)

st_install() {
    "$DOTFILES/bin/sh/install-oh-my-zsh"
}
