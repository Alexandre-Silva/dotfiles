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

    'aur:nrf5x-command-line-tools'
)

# st_profile() {
st_install() {
    Z=~/.local/zephyros-2.4
    if [ ! -d $Z ]; then
        echo "Installing zephyr in $Z with python venv in ~/.local/zephyros/venv"
        mkdir -p $Z/venv
        (
            python -m venv $Z/venv
            source $Z/venv/bin/activate

            pip install west

            west init $Z/ --mr zephyr-v2.4.0
            cd $Z
            west update

            west zephyr-export

            pip install -r $Z/zephyr/scripts/requirements.txt

        )

    else
        echo "Skipping installation of zephyros. Already installed."

    fi

    sdkver=0.12.1
    sdk=~/.local/zephyr-sdk-$sdkver
    if [ ! -d $sdk ]; then
        echo "Installing zephyr sdk $skdver in $sdk"
        wget \
            https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v$sdkver/zephyr-sdk-$sdkver-x86_64-linux-setup.run \
            -O /tmp/zephyr-sdk.run \
            --show-progress

        chmod +x /tmp/zephyr-sdk.run
        /tmp/zephyr-sdk.run -- -d $sdk

        sudo cp $sdk/sysroots/x86_64-pokysdk-linux/usr/share/openocd/contrib/60-openocd.rules /etc/udev/rules.d
        sudo udevadm control --reload

    else
        echo "Skipping installation of zephyr-sdk. Already installed."

    fi

    echo "When using zephyros don't forget to $Z/venv/bin/activate"
}

st_profile() {
    sdk_version=0.12.1
    sdk=~/.local/zephyr-sdk-$sdkver
    if [ -d $sdk ]; then
        export ZEPHYR_SDK_BASE="$sdk"
    fi

    if [ -d ~/.local/zephyros-2.4 ]; then
        export ZEPHYR_BASE="$HOME/.local/zephyros/zephyros-2.4"
    fi
}

st_rc() {
    if [ -z "$ZEPHYR_BASE" ]; then
        return
    fi

    function west() {
        if ! hash west &>/dev/null; then
            source $ZEPHYR_BASE/../venv/bin/activate
        fi

        unset -f west

        west "$@"
    }
}
