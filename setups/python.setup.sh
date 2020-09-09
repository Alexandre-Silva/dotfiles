#!/usr/bin/bash

packages=(
    "pm:python"
    "pm:python-pipenv"
    # "pip:poetry"
    # "aur:pyenv"
)

st_install() {
    curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py -o /tmp/get-poetry.py
    python /tmp/get-poetry.py
    source "$HOME/.poetry/env"

    poetry completions zsh > ~/.zfunctions/_poetry
    ~/.poetry/bin/poetry completions bash > /tmp/poetry.bash-completion
    sudo mv /tmp/poetry.bash-completion /etc/bash_completion.d/poetry.bash-completion
}

st_profile() {
    PATH="$(python -m site --user-base)/bin:${PATH}"

    # setup pyenv
    # export PYENV_ROOT="$HOME/.pyenv"

    # if which pyenv &> /dev/null; then
    #     eval "$(pyenv init -)"
    #     eval "$(pyenv virtualenv-init -)"
    # fi

    if [[ -d ~/.poetry ]]; then
        source "$HOME/.poetry/env"
    fi
}

st_rc() {
    pip-update-user() {
        pip list --user --outdated --format=freeze \
            | grep -v '^\-e' \
            | cut -d = -f 1 \
            | xargs -n1 pip install --user -U
    }

    pip-update-sys() {
        pip list --outdated --format=freeze \
            | grep -v '^\-e' \
            | cut -d = -f 1 \
            | xargs -n1 sudo pip install -U
    }
}
