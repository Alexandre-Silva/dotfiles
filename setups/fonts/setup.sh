#!/bin/bash

packages=(
    pm:{cairo,fontconfig,freetype2,jdk8-openjdk,jre8-openjdk,jre8-openjdk-headless}
)

links=()

function st_install() {
    # sudo ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
    # sudo ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
    # sudo ln -s /etc/fonts/conf.avail/10-hinting-slight.conf  /etc/fonts/conf.d

    local here="${DOTFILES}/setups/fonts"

    checked_cp() {
       local from="$1"
       local to="$1"

       if [[ -e "${to}" ]]; then
           local from_hash="$(md5sum "${from}" | cut -d ' ' -f 1 )"
           local to_hash="$(md5sum "${to}" | cut -d ' ' -f 1 )"
           if [[ "${to_hash}" != "${to_hash}" ]]; then
               warn "${to} exists and but is different from ${to}."
               warn "Therefore no changes will be made."
           fi
       else
           sudo cp --force --verbose "${from}" "${to}"
       fi
    }

    # dealing with local.conf
    checked_cp "${here}/local.conf" "/etc/fonts/local.conf"
    # jre font fix
    checked_cp "${here}/jre-fonts.sh" "/etc/profile.d/"
}


install_infinality() {
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

    # Verify if multilb is not active. if its not then the [multilib] section
    # cant still be present but commented out
    cp "$DOTFILES/setups/fonts/infinality.pacconf" ./
    if ! grep -E '^\[multilib\]$' /etc/pacman.conf ; then
        sed --in-place=.bak 's/^\(.*multilib.*\)$/#\0/' infinality.pacconf
    fi

    # join base pacman.conf with Infinality repos configs
    cat /etc/pacman.conf infinality.pacconf >pacman.conf.tmp
    sudo mv --force --verbose pacman.conf.tmp /etc/pacman.conf
    sudo chown root:root /etc/pacman.conf

    # Install infinality packages
    local packs=()
    for p in "freetype2" "fontconfig" "cairo";do
        packs+=( "$p-infinality-ultimate")
    done

    sudo pacman -S "${packs[*]}"
}
