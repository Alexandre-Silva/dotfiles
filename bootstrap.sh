#!/usr/bin/env bash

################################################################################
## CONFIGS
################################################################################
set -e

BASE_PACKAGES=( git )
DOTFILES_REPO="https://github.com/Alexandre-Silva/dotfiles"
DOTFILES="${HOME}/dotfiles"
ADM="${DOTFILES}/shell/lib/ADM"


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
        echo "----- ${DOTFILES} dir already exists. Assuming it's the correct latest one and skyping."
    else
        git clone --recursive --progress ${DOTFILES_REPO} ${DOTFILES}
    fi

    echo "---- Done"
    echo ""
}

function install-adm-base {
    echo "---- Installing base setup.sh and links"

    set +e

    adm install "${DOTFILES}/shell/shell.setup.sh"
    adm links

    chsh

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
