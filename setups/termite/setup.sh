#!/bin/bash

packages=(
    "pm:termite"
    "npm:base16-builder"  # for getting up-to-date theme coulours
    "aur:ttf-inconsolata-g"
)

links=(
    {"$DOTFILES/setups/",$HOME"/.config/"}termite
)

st_install() {
    local here="$DOTFILES/setups/termite"

    if [[ "$(hostname)" == "alex-desktop" ]]; then
        local font=11
    else
        local font=9
    fi

    if hash base16-builder 2>/dev/null; then
        local colors="$(base16-builder \
                            --scheme bright \
                            --template termite \
                            --brightness dark)"

    else # using fallback values
        local colors='
# $base16-builder -s bright -t termite -b dark
# fallback version
[colors]
# Base16 Bright
# Scheme: Chris Kempson (http://chriskempson.com)

foreground      = #e0e0e0
foreground_bold = #e0e0e0
cursor          = #e0e0e0
background      = #000000

# 16 color space
color0  = #000000
color1  = #fb0120
color2  = #a1c659
color3  = #fda331
color4  = #6fb3d2
color5  = #d381c3
color6  = #76c7b7
color7  = #e0e0e0
color8  = #b0b0b0
color9  = #fb0120
color10 = #a1c659
color11 = #fda331
color12 = #6fb3d2
color13 = #d381c3
color14 = #76c7b7
color15 = #ffffff

# 256 color space
color16 = #fc6d24
color17 = #be643c
color18 = #303030
color19 = #505050
color20 = #d0d0d0
color21 = #f5f5f5'
    fi

    # this comments out the cursor parameter to prevent the cursor from having
    # the same colour as the text (when it's over text)
    colors="$(sed 's/^cursor\ \{1,\}= #[0-9a-fA-F]\{6\}$/# \0/' <<< "${colors}")"

    FONT_SIZE=$font COLORS="${colors}" mo "$here/config.mo" >"$here/config"
}
