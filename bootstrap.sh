#!/usr/bin/env bash

################################################################################
## CONFIGS
################################################################################

BASE_PACKAGES=( git )
DOTFILES_REPO="https://github.com/Alexandre-Silva/dotfiles"
[ -z "$DOTFILES" ] && export DOTFILES="${HOME}/dotfiles"
[ -z "$ADM" ]      && export ADM="${DOTFILES}/shell/lib/ADM"


################################################################################
## DYNAMIC SETTINGS
################################################################################

if hash pacman >/dev/null 2>&1 ; then
    INSTALL=( pacman --needed -S )
elif hash apt >/dev/null 2>&1 ; then
    INSTALL=( apt install )
else
    echo "ERROR: cannot find a known package manager"
    exit -1
fi

################################################################################
## FUNCTIONS
################################################################################

function adm {
    source "${ADM}/adm.sh" "$@"
}

function install-base-packages {
    echo "---- installing base packages"

    if hash sudo >&/dev/null 2>&1; then
        sudo "${INSTALL[@]}" "${BASE_PACKAGES[@]}"
    else
        echo "---- Please enter root password"
        su root --command "$(echo "${INSTALL[@]}" "${BASE_PACKAGES[@]}" )"
    fi

    echo "---- Done"
    echo ""
}

function install-dotfiles {
    echo "---- Fetching dotfiles"

    if [[ -d ${DOTFILES} ]]; then
        git pull && git submodule sync --recursive && git submodule update --init --recursive
    else
        git clone --recursive --progress ${DOTFILES_REPO} ${DOTFILES}
    fi

    echo "---- Done"
    echo ""
}

function install-adm-base {
    echo "---- Installing base setup.sh and links"

    adm install "${DOTFILES}/shell/shell.setup.sh"
    adm link

    echo "---- Done"
    echo ""
}

function main {
    install-base-packages
    install-dotfiles
    install-adm-base
}


################################################################################
## MAIN
################################################################################

main "$@"
