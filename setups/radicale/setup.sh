#!/usr/bin/env bash

packages=(
    'aur:radicale'

    # options
    'pm:python-passlib'
    'pm:python-requests'
)

links=( "${ADM_DIR}/config" "${HOME}/.config/radicale/config")

st_install() {
    sudo install -m644 -D --owner=root --group=root "${ADM_DIR}/radicale@.service" '/etc/systemd/system/'
    sudo systemctl daemon-reload
    sudo systemctl enable "radicale@${USER}"
    sudo systemctl start "radicale@${USER}"
}
