#!/usr/bin/bash

packages=(
    "pm:ruby"
)

links=()

st_profile() {
    GEM_BIN="$HOME/.gem/ruby/2.7.0/bin"
    if [ -d "$GEM_BIN}"]; then
        export PATH="$GEM_BIN:$PATH"
    fi
}
