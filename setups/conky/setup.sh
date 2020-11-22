#!/usr/bin/env bash

packages=(
    'pm:conky'
)

links=( "${ADM_DIR}" "${XDG_CONFIG_HOME:-$HOME/.config}/conky" )
