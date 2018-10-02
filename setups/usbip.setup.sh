#!/usr/bin/bash

packages=( pm:usbip )

st_install() {
    sudo bash -c 'echo vhci-hcd >/etc/modules-load.d/usbip.conf'
    sudo modprobe 'vhci-hcd'
}
