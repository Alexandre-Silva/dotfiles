#!/usr/bin/env bash

packages=(
    'pm:deno'
)


st_profile() {
    if [[ -d "$HOME/.deno/bin" ]]; then export PATH="$HOME/.deno/bin:$PATH"
    fi
}
