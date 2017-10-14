#!/usr/bin/env bash

# There are several files involved in configuring a vm for passtrough:
#
# antergos.conf - /boot/loader/entries/antergos.conf - kernel parameters
# modprobe.d/vfio.conf - bind kernel module to graphics card
# mkinitcpio.conf - has configs for forcing the correct module load order

# add user to input and kvm group

packages=(
    qemu libvirt ovmf # The VM and shit
    virt-manager      # Desktop user interface for managing virtual machines
    ebtables dnsmasq  # default NAT/DHCP networking.
    bridge-utils      #  bridged networking.
    gnu-netcat        # remote management over SSH.
)
