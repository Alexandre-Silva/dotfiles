#!/usr/bin/bash

packages=(
    "pm:rust"
    "pm:cargo"
)



install() {
    __rs_init

    # get sources via PKGBUILD
    curl -sSf "$ARCH_PKGBUILD" > PKGBUILD
    makepkg --nobuild --nodeps

    # cp downloaded sources to SRC
    [ -d "$SRC" ] && rm --recursive --force "$SRC"
    mkdir --verbose --parents "$SRC"
    source ./PKGBUILD
    cp --recursive "src/rustc-$pkgver/src/"* "$SRC"

    __rs_install_racer

    __rs_clean
    return 0
}

profile() {
    __rs_init

    export RUST_SRC_PATH="$SRC"

    local cargo_bin="$HOME/.cargo/bin"
    if [ -d "$cargo_bin" ]; then
        # verifies if path already contains "cargo_bin"
        [[ ! ":$PATH:" == *":$cargo_bin:"* ]] && export PATH="$PATH:$cargo_bin"
    else
        error "Cargo should be installed but $cargo_bin not found"
    fi

    __rs_clean
}


## Helper functions
__rs_init() {
    SRC="$HOME/.local/src/rust"
    ARCH_PKGBUILD='https://git.archlinux.org/svntogit/community.git/plain/trunk/PKGBUILD?h=packages/rust'

    __rs_install_racer() {
        pattern_cargo='^.*\(([0-9]+\.[0-9]+\.[0-9]+)\).*$'
        pattern_racer='^.*([0-9]+\.[0-9]+\.[0-9]+).*$'

        version_cargo=$(cargo search racer)
        if [ $? -ne 0 ]; then
            warn "Could not search for latest version of racer. (Maybe the internets iz downz)"
            return 1
        fi

        echo "$version_cargo" | grep -E "$pattern" >/dev/null
        if [ $? -ne 0 ]; then
            error "Searching for racer in cargo yielded no hits"
            return 1
        fi

        if [ -f "$HOME/.cargo/bin/racer" ]; then
            version_racer=$(RUST_SRC_PATH="$SRC" "$HOME/.cargo/bin/racer" --version)
            if [ $? -ne 0 ]; then
                warn "Could not search for latest version of racer"
                echo "$version_racer"
                return 1
            fi
        else
            version_racer="Not_Installed"
        fi

        # sanatize for only version in format 1.2.3
        version_cargo=$(echo "$version_cargo" | sed -nr 's/'"$pattern_cargo"'/\1/p')
        version_racer=$(echo "$version_racer" | sed -nr 's/'"$pattern_racer"'/\1/p')

        printf "Racer <installed>/<cargo's> version: %s/%s\n" "$version_racer" "$version_cargo"

        if [[ "$version_cargo" == "$version_racer" ]]; then
            echo "Version match"
            return 0
        else
            echo "Version mis-match"
            #cargo uninstall racer && cargo install racer
            return $?
        fi
    }
}

__rs_clean() {
    unset SRC ARCH_PKGBUILD
    unset -f __rs_install_racer
}
