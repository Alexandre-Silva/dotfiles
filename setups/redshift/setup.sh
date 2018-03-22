packages=(
    "pm:redshift"
)

links=(
    {"$DOTFILES/setups/redshift/",$HOME"/.config/"}redshift.conf
    {"$DOTFILES/setups/redshift/",$HOME"/.config/autostart/"}redshift.desktop
)

st_rc() {
    alias fix-redshift='xrandr -o inverted && xrandr -o normal'
}
