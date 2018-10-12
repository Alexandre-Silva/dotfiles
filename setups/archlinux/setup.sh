#!/usr/bin/bash

depends=(
    "$ADM_DIR/../pacaur.setup.sh"
    "$ADM_DIR/../archlinux-java.setup.sh"
    "$ADM_DIR/../fonts/setup.sh"
    "$ADM_DIR/../xdg/setup.sh"
)

packages=(
    pm:pacman-contrib
)
