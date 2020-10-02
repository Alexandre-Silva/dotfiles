#!/usr/bin/bash

packages=()

links=()


st_install() {
    # systemd units files must be linked using 'systemctl link' if their to be symlinked

    # services and timers still need to be started/enabled

    systemctl --user link "${DOTFILES}/systemd/"secure-tunnel@.service

    systemctl --user link "${DOTFILES}/systemd/reddit-wallpaper-fetcher.service"
    systemctl --user link "${DOTFILES}/systemd/reddit-wallpaper-fetcher.timer"

    systemctl --user link "${DOTFILES}/systemd/socks5@.service"

    systemctl --user link "${DOTFILES}/systemd/tunnel-sshd@.service"

    systemctl --user daemon-reload
}
