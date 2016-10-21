#!/usr/bin/bash

packages=(
    "pm:rust"{,-docs,-racer}
    "aur:rust-src"
    "pm:cargo"
)

links=()

st_profile() {
    export RUST_SRC_PATH="/usr/src/rust/src"

    local cargo_bin="$HOME/.cargo/bin"
    if [ -d "$cargo_bin" ]; then
        # verifies if path already contains "cargo_bin"
        [[ ! ":$PATH:" == *":$cargo_bin:"* ]] && export PATH="$PATH:$cargo_bin"
    else
        error "Cargo should be installed but $cargo_bin not found"
    fi
}
