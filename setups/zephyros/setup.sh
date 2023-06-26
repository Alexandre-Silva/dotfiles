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

    'pm:dtc' # Device Tree Compiler

    'pm:python-pip'
    'pm:python-setuptools'
    'pm:python-wheel'

    'pm:base-devel'
    'pm:gcc'
    'pm:gcc-libs'
    # 'pm:lib32-gcc-libs'

    'pm:sdl2'

    'aur:nrf5x-command-line-tools'
)

_ZP_VER=3.4.0
_ZP_HOME=~/.local/share/zephyros-$_ZP_VER
_ZPSDK_VER=0.16.1
_ZPSDK_HOME=~/.local/share/zephyr-sdk-$_ZPSDK_VER

st_install() {
    Z=$_ZP_HOME
    if [ ! -d $Z ]; then
        echo "Installing zephyr in $Z with python venv in ~/.local/zephyros/venv"
        mkdir -p $Z/venv
        (
            python -m venv $Z/venv
            source $Z/venv/bin/activate

            pip install west

            west init $Z/ --mr zephyr-v$_ZP_VER
            cd $Z
            west update

            west zephyr-export

            pip install -r $Z/zephyr/scripts/requirements.txt

        )

    else
        echo "Skipping installation of zephyros. Already installed."

    fi

    sdkver=$_ZPSDK_VER
    sdk=$_ZPSDK_HOME
    if [ ! -d $sdk ]; then
        (
          echo "Installing zephyr sdk $skdver in $sdk"

          cd /tmp
          wget \
              https://github.com/zephyrproject-rtos/sdk-ng/releases/download/v$sdkver/zephyr-sdk-${sdkver}_linux-x86_64.tar.xz \
              --show-progress

          tar xvf zephyr-sdk-${sdkver}_linux-x86_64.tar.xz
          mv zephyr-sdk-$sdkver $sdk
          cd ~/.local/share/zephyr-sdk-$sdkver
          ./setup.sh

          sudo cp ./sysroots/x86_64-pokysdk-linux/usr/share/openocd/contrib/60-openocd.rules /etc/udev/rules.d
          sudo udevadm control --reload
        )

    else
        echo "Skipping installation of zephyr-sdk. Already installed."

    fi

    echo "When using zephyros don't forget to $Z/venv/bin/activate"
}

st_profile() {
    if [ -d $_ZPSDK_HOME ]; then
        export ZEPHYR_SDK_BASE="$_ZPSDK_HOME"
        export PATH="${ZEPHYR_SDK_BASE}/sysroots/x86_64-pokysdk-linux/usr/bin:$PATH"
    fi

    if [ -d $_ZP_HOME ]; then
        export ZEPHYR_BASE="$_ZP_HOME/zephyr"
    fi
}

st_rc() {
    if [ -z "$ZEPHYR_BASE" ]; then
        return
    fi

    function west() {
        if ! hash west &>/dev/null; then
            source $_ZP_HOME/venv/bin/activate
        fi

        unset -f west

        west "$@"
    }
}
