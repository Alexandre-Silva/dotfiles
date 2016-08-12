#!/bin/bash

packages=(
    "pm:nodejs"
    "pm:npm"
)

st_install() {
    sudo npm install -g elm elm-oracle
}
