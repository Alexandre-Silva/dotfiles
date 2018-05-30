#!/usr/bin/bash

packages=(
    pm:lua
    pm:luarocks
)

st_profile() {
    # the subshell cmd outputs the something along the lines of: 'export
    # LUA_PATH=...' which is then evaluated.
    if hash luarocks &>/dev/null; then
        eval "$(luarocks path --bin)"
    fi
}
