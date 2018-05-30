#!/usr/bin/bash

packages=(
    "pm:base-devel"
)

function st_install() {
    AUR_COWER_GIT="https://aur.archlinux.org/cower.git"
    AUR_PACAUR_GIT="https://aur.archlinux.org/pacaur.git"

    lil_makepkg() {
        makepkg --needed --noconfirm --syncdeps --rmdeps --install
    }

    if [[ "$(uname -m)" =~ armv* ]]; then
        sudo pacman -S cower;
    else
        if ! hash cower &>/dev/null; then
            git clone $AUR_COWER_GIT
            cd cower; lil_makepkg; cd ..
        fi
    fi

    if ! hash cower &>/dev/null; then
        git clone $AUR_PACAUR_GIT
        cd pacaur; lil_makepkg; cd ..
    fi

    btr_unset_f lil_makepkg
}
