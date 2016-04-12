#!/bin/bash

MSC_GEN_FLAGS=(-T png -Pno)
PLANT_FLAGS=(-tpng)

function _prepare() {
    [ -d build ] || mkdir build -v
}

function _clean() {
    [ -d build ] && rm -vrf build
}

function _build() {
    local files=("$@")

    _prepare

    for f in $files; do
        case $f in
            *.msc)
                of="build/"${f#src/}
                of=${of%.msc}".png"

                echo "building $f --> $of"

                msc-gen $MSG_GEN_FLAGS -i $f -o $of
                ;;

            *.plant)
                echo "building $f"

                plantuml $PLANT_FLAGS $f -o $(pwd)/build
                ;;

            *) echo "Unreckognized extension: $f";;
        esac
    done
}

function _build-all() {
    local files=$(find src -type f -iname "*.msc" -or -type f -iname "*.plant")
    _build "$files"
}


function _watch() {
    stdbuf -oL inotifywait src \
           --event modify \
           --monitor \
           --recursive |
        while IFS= read -r line
        do
            echo "$line"

            watched_file=$(echo "$line" | cut -d " " -f 1) # should alwasy be src
            event=$(echo "$line" | cut -d " " -f 2)
            event_file=$(echo "$line" | cut -d " " -f 3)

            file="$watched_file$event_file"

            case $event in
                CREATE|MODIFY) _build "$file" ;;
                DELETE) _clean; _build-all ;;
                *) echo "unexpected event"
            esac
        done
}

function _launch_feh() {
    feh -R 3 build &
}

case $1 in
    prepare|p)          _prepare ;;
    build|b)            _build-all ;;
    clean|c)            _clean ;;
    watch|w)            _watch ;;
    launch-feh|lf)      _launch_feh ;;
esac
