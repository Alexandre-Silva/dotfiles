#!/usr/bin/env bash

depends=()

packages=(
    'pm:make'
    'pm:ninja'
    'pm:cmake'
    'pm:ccache'

    'pm:gperf'
    'pm:wget'
    'pm:xz'
    'pm:file'

    'pm:python-pip'
    'pm:python-setuptools'
    'pm:python-wheel'

    'pm:base-devel'
    'pm:gcc'
    'pm:gcc-libs'
    'pm:lib32-gcc-libs'

    'pm:sdl2'

    'pm:nrf5x-command-line-tools'
)

# st_profile() {
st_rc() {
    sdk_version=0.12.1
    if [ -d ~/.local/zephyr-sdk-$sdk_version ]; then
        ;
    fi
}
