#!/bin/bash

packages=( 
 "pm:syncthing" 
 "aur:syncthingtray" 
)

__config="${XDG_CONFIG_HOME:-$HOME/.config}"
links=( )
