#!/usr/bin/env bash

packages=(
    'pm:openssh'
    'pm:xorg-xauth'
)

st_rc() {
    ssh-getip4() {
        ssh "$1" "ip addr show" | sed -n 's/[[:space:]]\+inet \(.*\)\/24.*/\1/p'
    }
}
