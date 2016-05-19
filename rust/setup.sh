#!/usr/bin/bash

p="$HOME/.local/src/rust"
[ -d "$p" ] && export RUST_SRC_PATH="$p" || echo "ERROR: rust source not found."

cargo_bin="$HOME/.cargo/bin"
[ -d "$cargo_bin" ] && export PATH="$PATH:$cargo_bin"
