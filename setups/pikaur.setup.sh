#!/usr/bin/bash

packages=(
    "pm:base-devel"
)

function st_install() {
    AUR_PIKAUR_GIT="https://aur.archlinux.org/pikaur.git"

    lil_makepkg() {
        makepkg --needed --noconfirm --syncdeps --rmdeps --install
    }

    if ! hash pikaur &>/dev/null; then
        git clone $AUR_PIKAUR_GIT
        cd pikaur; lil_makepkg; cd ..
    fi

    btr_unset_f lil_makepkg
}
