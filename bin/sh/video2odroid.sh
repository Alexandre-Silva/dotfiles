#!/usr/bin/env bash

# AVC --> h264
# HEVC --> h265


parse_codec() {
    local format=$(mediainfo --Output=JSON "$1" \
                       | jq -r '.media.track | map(select(."@type" == "Video"))[0].Format')

    local bitdepth=$(mediainfo --Output=JSON "$1" \
                         | jq -r '.media.track | map(select(."@type" == "Video"))[0].BitDepth')

    echo "$format:$bitdepth"
}

main() {
    local args=( "$@" )
    local files_len=$(( "${#args[@]}" - 2 ))
    local files=( "${args[@]:0:$files_len}" )
    local host="${args[-2]}"
    local target="${args[-1]}"

    for file in "${files[@]}"; do
        local format=$(parse_codec "$file")

        if [[ $format = AVC:8 ]] || [[ $format = HEVC:8 ]]; then
            rsync -rult "$file" "$host":"$target"
            notify-send "Copy to OC2 done"

        else
            notify-send "Encoding & transferring: $file"

            ffmpeg -i "$file" -c:v libx265 -vf format=yuv420p -preset fast -c:a copy -f matroska - \
                | ssh $host "cat > '""${target}""/$(basename "${file}")'"

            notify-send "Encoding & transferring complete: $file"
        fi
    done

}

main "$@"
