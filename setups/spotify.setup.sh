#!/usr/bin/bash

packages=(
    aur:spotify
    pm:lib
    pm:xdotool
    pm:libcurl-gnutls
    pm:dunst
)

links=()


st_install() {
    echo "recommending install https://github.com/SecUpwN/Spotify-AdKiller"
}

st_rc() {
    pactl-index-by-name() {
        local name="$1"
        pactl list sink-inputs |
            awk -v name=$name '/Sink Input #/{idx = $3};
                               { if ($1 == "media.name" && $3 == "\""name"\"")
                                 {  gsub(/#/, "", idx); print idx } };'
    }

    spotify-addmute-watch(){
        local muted=2
        while IFS= read -r line; do
            # local title="$(playerctl metadata xesam:title)"
            local title="$line"
            echo $title
            if [[ ( $title == *"Spotify"* || $title == *"Advertisement"* ) ]]; then
                if [[ "$muted" == 1 ]]; then
                    continue
                fi

                sleep 0.5 # Some adds still play for some time after title change

                for index in $(pactl-index-by-name Spotify); do
                    pactl set-sink-input-mute "$index" 1
                done

                muted=1

                notify-send --urgency=low  spotify-addmute 'muting'

            elif [[ "$muted" != 0 ]]; then
                for index in $(pactl-index-by-name Spotify); do
                    pactl set-sink-input-mute "$index" 0
                done

                muted=0

                notify-send --urgency=low  spotify-addmute 'unmuting'
            fi
        done < <(playerctl -p spotify -F metadata xesam:title)
    }
}
