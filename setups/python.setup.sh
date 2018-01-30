#!/usr/bin/bash

packages=(
    "pm:python"
    "aur:pyenv"
)

st_profile() {
    PATH="$(python -m site --user-base)/bin:${PATH}"

    # setup pyenv
    export PYENV_ROOT="$HOME/.pyenv"

    if which pyenv > /dev/null; then
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    fi
}
