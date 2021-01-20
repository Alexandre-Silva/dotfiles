#!/usr/bin/bash

packages=()

links=()


st_install() {
    # systemd units files must be linked using 'systemctl link' if their to be symlinked

    # services and timers still need to be started/enabled

    systemctl --user link "${DOTFILES}/systemd/reddit-wallpaper-fetcher.service"
    systemctl --user link "${DOTFILES}/systemd/reddit-wallpaper-fetcher.timer"

    systemctl --user link "${DOTFILES}/systemd/socks5@.service"

    systemctl --user daemon-reload


    sudo systemctl link "${DOTFILES}/systemd/tunnel-sshd2@.service"

    sudo systemctl daemon-reload
}
