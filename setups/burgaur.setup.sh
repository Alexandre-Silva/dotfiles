#!/usr/bin/bash

packages=(
    "pm:base-devel"
    "pm:ranger"
)

AUR_COWER_GIT="https://aur.archlinux.org/cower.git"
AUR_BURGAUR_GIT="https://aur.archlinux.org/burgaur.git"

function st_install() {
    if [[ "$(uname -m)" =~ armv* ]]; then
        sudo pacman -S cower;
    else
        git clone $AUR_COWER_GIT
        cd cower
        makepkg --needed --noconfirm -sri
        cd ..
    fi

    git clone $AUR_BURGAUR_GIT
    cd burgaur
    makepkg --needed --noconfirm -sri
    cd ..
}

function st_profile() {
    # default
    # export BURGAUR_TARGET_DIR="/var/tmp/"

    export BURGAUR_FILE_MANAGER="ranger"
}
