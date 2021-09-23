#!/usr/bin/env bash

packages=(
    pm:autorandr
)

st_install() {
    sudo systemctl enable --now autorandr

    echo Use \'autorandr --save the-profile-name\' for storing profiles
}
