#!/usr/bin/bash

packages=(
    "aur:pyenv"
)

st_profile() {
    export PYENV_ROOT="$HOME/.pyenv"

    if which pyenv > /dev/null; then
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    fi
}
