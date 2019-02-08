#!/usr/bin/bash

packages=(
    "pm:python"
    "pm:python-pipenv"
    "pip:poetry"
    "aur:pyenv"
)

st_install() {
    poetry completions zsh > ~/.zfunctions/_poetry
    sudo poetry completions bash > /etc/bash_completion.d/poetry.bash-completion
    curl -sSL https://raw.githubusercontent.com/sdispater/poetry/master/get-poetry.py | python
}

st_profile() {
    PATH="$(python -m site --user-base)/bin:${PATH}"

    # setup pyenv
    export PYENV_ROOT="$HOME/.pyenv"

    if which pyenv &> /dev/null; then
        eval "$(pyenv init -)"
        eval "$(pyenv virtualenv-init -)"
    fi

    if [[ -d ~/.poetry ]]; then
        export PATH="$HOME/.poetry/bin:$PATH"
    fi
}

st_rc() {
    if which pipenv &> /dev/null; then
        # NOTE: Instead of using the comment snippet below, we copy pasted it
        # and removed the auto-load ... && compinit since it's already done
        # latter on. Also note that doing it here wouldn't break anything but
        # would perceivable slow it down.

        # eval "$(pipenv --completion)"

        if [[ -n $ZSH_VERSION ]]; then
            _pipenv() {
                eval $(env COMMANDLINE="${words[1,$CURRENT]}" _PIPENV_COMPLETE=complete-zsh  pipenv)
            }
            if [[ "$(basename ${(%):-%x})" != "_pipenv" ]]; then
                # autoload -U compinit && compinit
                compdef _pipenv pipenv
            fi

        elif [[ -n $BASH_VERSION ]]; then
            _pipenv_completion() {
                local IFS=$'\t'
                COMPREPLY=( $( env COMP_WORDS="${COMP_WORDS[*]}" \
                                   COMP_CWORD=$COMP_CWORD \
                                   _PIPENV_COMPLETE=complete-bash $1 ) )
                return 0
            }

            complete -F _pipenv_completion -o default pipenv
        fi

    fi


    pip-update-user() {
        pip list --user --outdated --format=freeze \
            | grep -v '^\-e' \
            | cut -d = -f 1 \
            | xargs -n1 pip install --user -U
    }
}
