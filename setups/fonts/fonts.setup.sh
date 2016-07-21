#!/bin/bash

function st_install() {
    # If Infinality is present in pacman.conf we assume that the repos are installed
    grep "Infinality" /etc/pacman.conf >/dev/null && return 0

    warn "Initializing dirmngr. Once it finishes send EOF (ctrl-d) to exit."

    sudo dirmngr
    sudo pacman-key --recv-keys 962DDE58

    echo
    warn "The key's finger should be:"
    cat <<-EOF
        pub   rsa2048 2013-04-22 [SC]
            A924 4FB5 E93F 11F0 E975  337F AE68 66C7 962D DE58
        uid           [  full  ] bohoomil (dev key) <bohoomil@zoho.com>
        sub   rsa2048 2013-04-22 [E]

EOF
    echo "And the received key's finger is:"
    pacman-key --finger 962DDE58

    echo "Is it correct (y/[n])"
    while read answer; do
        case "$answer" in
            Yes|yes|Y|y) break ;;
            No|no|N|n) return 0 ;;
            *) warn "Invalid answer" ;;
        esac
    done

    sudo pacman-key --lsign-key 962DDE58

    cat /etc/pacman.conf "$DOTFILES/setups/fonts/infinality.pacconf" >pacman.conf.tmp
    sudo mv --force --verbose pacman.conf.tmp /etc/pacman.conf

    local packs=()
    for p in "freetype2","fontconfig","cairo";do
        packs+=( "$p-infinality-ultimate")
        done

    sudo pacman -S "${packs[*]}"
}
