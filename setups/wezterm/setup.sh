#!/usr/bin/env bash

packages=(
  'pm:wezterm'
  'pm:wezterm-shell-integration'
  'pm:wezterm-terminfo'
)

links=( "${ADM_DIR}" "${XDG_CONFIG_HOME:-$HOME/.config}/wezterm" )
