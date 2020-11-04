#!/usr/bin/bash

depends=(
    "$ADM_DIR/../pikaur.setup.sh"
    "$ADM_DIR/../archlinux-java.setup.sh"
    "$ADM_DIR/../fonts/setup.sh"
    "$ADM_DIR/../xdg/setup.sh"
)

packages=(
    pm:pacman-contrib
    pm:pigz # drop in replacemente for gzip with parallel compression
    pm:ntp
    aur:kernel-modules-hook
)

links=( "${ADM_DIR}/pacman" "${XDG_CONFIG_HOME:-$HOME/.config}/pacman" )


st_install() {
    # for kernel-modules-hook
    sudo systemctl daemon-reload
    sudo systemctl enable linux-modules-cleanup
    sudo systemctl enable --now ntpd
}
