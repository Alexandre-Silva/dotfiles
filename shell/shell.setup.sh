packages=(
    "pm:zsh"
    "pm:zsh-completions"
    "pm:zsh-doc"
)


links=(
    "$DOTFILES/shell/bashrc" ~/.bashrc
    "$DOTFILES/shell/profile" ~/.profile

    "$DOTFILES/shell/zshrc" ~/.zshrc
    "$DOTFILES/shell/zprofile" ~/.zprofile
)

st_install() {
    "$DOTFILES/bin/sh/install-oh-my-zsh"
}
