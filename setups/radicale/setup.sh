#!/usr/bin/env bash

packages=(
    'pm:radicale'

    # options
    'pm:python-passlib'
    'pm:python-requests'
    'pm:python-dulwich'
)

links=( "${ADM_DIR}/config" "${HOME}/.config/radicale/config")

st_install() {
    sudo install -m644 -D "${ADM_DIR}/radicale@.service" '/etc/systemd/service/'
    sudo systemctl daemon-reload
    sudo systemctl enable "radicale@${USER}"
    sudo systemctl start "radicale@${USER}"
}
