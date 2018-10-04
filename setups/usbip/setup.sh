#!/usr/bin/bash

packages=( pm:usbip )

links=( "${ADM_DIR}/usbip-detachAll.sh" "${HOME}/.bin/usbip-detachAll" )

st_install() {
    sudo bash -c 'echo vhci-hcd >/etc/modules-load.d/usbip.conf'
    sudo modprobe 'vhci-hcd'
    sudo cp "${ADM_DIR}"/*.service /etc/systemd/system/
}
