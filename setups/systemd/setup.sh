#!/usr/bin/bash

packages=()

links=()


st_install() {
    # systemd units files must be linked using 'systemctl link' if their to be symlinked
    systemctl --user link "${DOTFILES}/setups/systemd/"secure-tunnel@.service
    systemctl --user daemon-reload
}
