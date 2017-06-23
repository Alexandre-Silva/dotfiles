#!/usr/bin/bash

packages=()

links=( {"${DOTFILES}/setups/systemd/","${HOME}/.config/systemd/user/"}secure-tunnel@.service )


st_install() {
    systemctl --user daemon-reload
}
