#!/usr/bin/bash

packages=(
    "pm:htop"
    "pm:iotop"
    "pm:ntop"
)

st_rc() {
    alias toph=htop
    alias topio='sudo iotop'
    alias topn='sudo ntop'
}
