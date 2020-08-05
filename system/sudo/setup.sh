#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

packages=()

st_install() {
    if ! groups | grep sudo &>/dev/null; then
        echo "WARNING: add ${USER} to group sudo plz! and copy ${DOTFILES}/system/sudo/sudoers to /etc/sudoers"
        return
    fi
}
