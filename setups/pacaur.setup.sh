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
        git clone $AUR_COWER_GIT
        cd cower; lil_makepkg; cd ..
    fi

    git clone $AUR_PACAUR_GIT
    cd pacaur; lil_makepkg; cd ..

    btr_unset lil_makepkg
}
