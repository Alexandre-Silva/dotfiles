#!/usr/bin/env bash

packages=(
    pm:bluez
    pm:bluez-utils
    pm:bluez-hid2hci
    pm:blueman

    # pm:pulseaudio-bluetooth

    ## pulseaudio-bluetooth but with LDAC, APTX, APTX-HD, AAC support, extended configuration for SBC
    #aur:pulseaudio-modules-bt
    aur:pulseaudio-modules-bt-git
)
