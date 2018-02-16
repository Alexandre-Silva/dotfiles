#!/usr/bin/bash

packages=(
    "pm:git"
    "pm:sdl2"{,_ttf}
    "pm:spice"{,-protocol}
    "pm:openssl"
    "pm:fontconfig"
    "pm:libx11"
    "pm:ttf-freefont"
)

st_install() {
    echo "Installation is a bit hands on"
    echo "see https://looking-glass.hostfission.com/quickstart"
}

st_rc() {
    ivshmem-server-lk() {
        touch /dev/shm/looking-glass
        chown $USER:kvm /dev/shm/looking-glass
        chmod 660 /dev/shm/looking-glass

        local mem=$(python -c 'import math; print(math.ceil((1920 * 1080 * 4 * 2 + 4224) / (1024**2)))' )
        ivshmem-server -p /tmp/ivshmem.pid -S /tmp/ivshmem_socket -l "${mem}M" -n 8 "$@"
    }
}
