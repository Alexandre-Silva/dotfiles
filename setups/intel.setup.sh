#!/usr/bin/env bash

depends=( "${ADM_DIR}/hardware_acceleration.setup.sh" )

packages=(
    'pm:mesa'

    # intel specific drivers
    'pm:libva-intel-driver'
    'pm:libvdpau-va-gl'
)

pm_profile() {
    export LIBVA_DRIVER_NAME="i965"
    export VDPAU_DRIVER="va_gl"
}
