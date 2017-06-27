#!/bin/bash

function main() {
    local internal="enp14s0"
    local external="wlp13s0"

    echo 1 > /proc/sys/net/ipv4/ip_forward

    /sbin/iptables -t nat -A POSTROUTING -o "$external" -j MASQUERADE
    /sbin/iptables -A FORWARD -i "$external" -o "$internal" -m state --state RELATED,ESTABLISHED -j ACCEPT
    /sbin/iptables -A FORWARD -i "$internal" -o "$external" -j ACCEPT
}

main
