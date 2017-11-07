#!/usr/bin/env bash

depends=( "${ADM_DIR}/hardware_acceleration.setup.sh" )

packages=(
    'pm:mesa'
    'pm:lib32-mesa'
    'pm:xf86-video-amdgpu'
    'om:xf86-video-ati'
    'aur:radeon-profile-git' # details, overclocking and fan control

    # hardware accel stuff
    'pm:mesa-vdpau'
    'pm:lib32-mesa-vdpau'

)

pm_profile() {
    export LIBVA_DRIVER_NAME="vdpau"
    export VDPAU_DRIVER="radeonsi"
}
