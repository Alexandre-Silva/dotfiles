#!/usr/bin/env bash

function __tmux_lk() {
    local filter="$1"
    tmux list-keys \
        | awk '/'$filter'/ { sub(/^bind-key (  |-r) -T '$filter' */, ""); print }' \
        | sort --key=2 --ignore-leading-blanks

}

function main() {
    echo '### With prefix ###'
    __tmux_lk prefix

    echo " "
    echo '### Without prefix ###'
    __tmux_lk root
}

main "$@"
