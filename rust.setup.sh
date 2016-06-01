#!/usr/bin/bash

packages=(
    "pm:rust"
    "pm:cargo"
)

__SETUP_RUST_SRC="$HOME/.local/src/rust"

install() {
    local SRC="$__SETUP_RUST_SRC"

    curl -sSf \
         'https://git.archlinux.org/svntogit/community.git/plain/trunk/PKGBUILD?h=packages/rust' \
         > PKGBUILD

    makepkg --nobuild --nodeps

    source ./PKGBUILD

    [ -d "$SRC" ] && rm --recursive --force "$SRC"
    mkdir --verbose --parents "$SRC"
    cp --recursive "src/rustc-$pkgver/src" "$SRC"

    local cargo_bin="$HOME/.cargo/bin"
    [ -d "$cargo_bin" ] && export PATH="$PATH:$cargo_bin"

    if [ -f "$cargo_bin/racer/racer" ]; then
        cargo uninstall racer
    fi
    cargo install racer
}

profile() {
    export RUST_SRC_PATH="$__SETUP_RUST_SRC"
}
