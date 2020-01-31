#!/usr/bin/bash

packages=(
    "pm:ruby"
    "pm:ruby-docs"
    "pm:ruby-rdoc"
    "pm:rubygems"
)

links=()

st_profile() {
    if hash ruby &>/dev/null; then
        PATH="$PATH:$(ruby -e 'puts Gem.user_dir')/bin"
    fi
}
