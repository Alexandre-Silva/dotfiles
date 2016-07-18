#!/usr/bin/bash

packages=(
    "pm:rust"
    "pm:cargo"
)

st_install() {
    __rs_init

    __rs_install_sources
    __rs_install_racer

    __rs_clean
    return 0
}

st_profile() {
    # Verifies if rust.setup.sh was installed
    which rustc cargo >/dev/null 2>&1 || return 0

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

    __rs_install_sources() {
        # get sources via PKGBUILD
        curl -sSf "$ARCH_PKGBUILD" > PKGBUILD
        local upstream_sum=$(md5sum "PKGBUILD" | cut -d " " -f 1)

        local local_sum=
        [ -f "$SRC/PKGBUILD" ] && local_sum=$(md5sum "$SRC/PKGBUILD" | cut -d " " -f 1)

        echo $local_sum $upstream_sum
        if [[ "$local_sum" != "$upstream_sum" ]]; then
            echo "Updating Rust sources"

            makepkg --nobuild --nodeps

            # cp downloaded sources to SRC
            [ -d "$SRC" ] && rm --recursive --force "$SRC"
            mkdir --verbose --parents "$SRC"
            source ./PKGBUILD
            cp --recursive "src/rustc-$pkgver/src/"* "$SRC"
            cp ./PKGBUILD "$SRC"

        else
            echo "Rust sources up-to-date"
        fi
    }

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
            return 0
        else
            echo "Updating racer"
            cargo uninstall racer && cargo install racer
            return $?
        fi
    }
}

__rs_clean() {
    btr_unset SRC ARCH_PKGBUILD
    btr_unset_f __rs_install_racer __rs_install_sources
}
