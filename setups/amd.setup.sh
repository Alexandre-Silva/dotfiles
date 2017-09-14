#!/usr/bin/env bash

packages=(
    'pm:mesa'
    'pm:lib32-mesa '

    'pm:xf86-video-amdgpu'

    # for hardware acceleration stuff see: https://wiki.archlinux.org/index.php/Hardware_video_acceleration
    'pm:libva-mesa-driver'
    'pm:vdpauinfo'
    'pm:mesa-vdpau'
    'pm:lib32-mesa-vdpau'

    'pm:libva-vdpau-driver'
    'pm:libva-utils'
)

pm_profile() {
    export LIBVA_DRIVER_NAME="vdpau"
    export VDPAU_DRIVER="radeonsi"
}
