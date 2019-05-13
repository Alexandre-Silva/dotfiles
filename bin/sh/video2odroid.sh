#!/usr/bin/env bash

# AVC --> x264
# HEVC --> x265


parse_codec() {
    local format=$(mediainfo --Output=JSON "$1" \
                       | jq '.media.track | map(select(."@type" == "Video"))[0].Format')

    local bitdepth=$(mediainfo --Output=JSON "$1" \
                         | jq '.media.track | map(select(."@type" == "Video"))[0].BitDepth')

    echo "$format:$bitdepth" | sed 's/\"//g'
}

main(){
    local args=( "$@" )

    local file="${args[0]}"
    local host="${args[1]}"
    local target="${args[2]}"
    local format=$(parse_codec "$file")

    if [[ $format = AVC:8 ]] || [[ $format = HEVC:8 ]]; then
        rsync -rult "$file" "$host":"$target"
        notify-send "Copy to OC2 done";

    else
        notify-send "Encoding & transferring: $file"

        ffmpeg -i "$file" -c:v libx265 -vf format=yuv420p -c:a copy -f matroska - \
            | ssh $host "cat > '""${target}""/$(basename "${file}")'"

        notify-send "Encoding & transferring complete: $file"

    fi

}


main "$@"
