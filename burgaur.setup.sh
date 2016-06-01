
packages=(
    "pm:base-devel"
)

AUR_COWER_GIT="https://aur.archlinux.org/cower.git"
AUR_BURGAUR_GIT="https://aur.archlinux.org/burgaur.git"

install() {
    git clone $AUR_COWER_GIT
    cd cower
    makepkg --needed --noconfirm -sri
    cd ..

    git clone $AUR_BURGAUR_GIT
    cd burgaur
    makepkg --needed --noconfirm -sri
    cd ..
}
