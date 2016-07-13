packages=(
    {"freetype2","fontconfig","cairo"}-infinality-ultimate
    "jdk8-openjdk-infinality"
)

function st_install() {
    sudo dirmngr

    pacman-key -r 962DDE58
    pacman-key -f 962DDE58
    pacman-key --lsign-key 962DDE58

}
