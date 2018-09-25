#!/usr/bin/bash

packages=(
    "pm:rustup"
    "pm:rust"{fmt,-docs,-racer}
    "aur:rust-src"
)

links=()

st_install() {
    rustup default stable
    rustup component add rust-src
    rustup completions zsh > ~/.zfunctions/_rustup
}

st_profile() {
    export RUST_SRC_PATH="$HOME/.rustup/toolchains/stable-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/src"

    local cargo_bin="$HOME/.cargo/bin"
    if [ -d "$cargo_bin" ]; then
        # verifies if path already contains "cargo_bin"
        [[ ! ":$PATH:" == *":$cargo_bin:"* ]] && export PATH="$PATH:$cargo_bin"
    fi
}
