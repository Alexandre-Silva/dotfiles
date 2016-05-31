
packages=(
    "pm:base-devel"
)

AUR_COWER_GIT="https://aur.archlinux.org/cower.git"
AUR_BURGAUR_GIT="https://aur.archlinux.org/burgaur.git"

install() {
    if [ -f /tmp/ADM ] || [ -d /tmp/ADM ]; then
        error " /tmp/ADM already exists. Possibly previous installion did not exit safely."
        return 1;
    fi

    mkdir /tmp/ADM && cd /tmp/ADM

    git clone $AUR_COWER_GIT
    cd cower
    makepkg --needed --noconfirm -sri
    cd ..

    git clone $AUR_BURGAUR_GIT
    cd burgaur
    makepkg --needed --noconfirm -sri
    cd ..

    rm -rf /tmp/ADM
}
