#!/bin/bash

packages=(
    "pm:rsync"
    "aur:canto-"{daemon,curses}
)

function st_install() {
    warn "Dont forget to activate sync-rsync.py plugin"
    warn "(can be found in /usr/lib/canto/plugins)"
}
