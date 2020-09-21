#!/usr/bin/bash

packages=(
    aur:spotify
    pm:lib
    pm:xdotool
    pm:libcurl-gnutls
)

links=()


st_install() {
    echo "recommending install https://github.com/SecUpwN/Spotify-AdKiller"
}

st_rc() {
    pacmd-index-by-name() {
        local name="$1"
        pacmd list-sink-inputs |
            awk -v name=$name '/index:/{idx = $2};
                               /state:/{state = $2};
                               { if ($1 == "application.name" && $3 == "\""name"\"" && state == "RUNNING")
                                 { print idx } };'
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

                local index="$(pacmd-index-by-name Spotify)"
                pacmd set-sink-input-mute "$index" true
                muted=1

                notify-send --urgency=low  spotify-addmute 'muting'

            elif [[ "$muted" != 0 ]]; then
                local index="$(pacmd-index-by-name Spotify)"
                pacmd set-sink-input-mute "$index" false
                muted=0

                notify-send --urgency=low  spotify-addmute 'unmuting'
            fi
        done < <(playerctl -p spotify -F metadata xesam:title)
    }
}
