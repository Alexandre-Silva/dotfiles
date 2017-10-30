#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

main() {
    sudo sh -c 'echo 1 > /sys/bus/pci/devices/0000:00:03.1/remove'
    sudo sh -c 'echo 1 > /sys/bus/pci/rescan'
}

main "$@"
