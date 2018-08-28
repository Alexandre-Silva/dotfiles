#!/usr/bin/bash

packages=(
    "pm:flatpak"
)

links=(
    "${ADM_DIR}/discord.sh" $HOME"/.bin/discord"
)

function st_install() {
    sudo flatpak install flathub com.discordapp.Discord
}
