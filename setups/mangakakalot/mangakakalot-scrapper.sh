#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


tmp=$(mktemp -d /tmp/mangakakalot-scapper.XXXXXX)
# tmp=/tmp/mangakakalot-scapper.APaxZW

template="$1";shift
out_dir="$1";shift
python3 "$DIR/mangakakalot-scrapper.py" "$tmp" "$@"

for series in "$tmp/"* ; do
    for chapter in "$series/"* ; do
        series_name=$(basename "$series")
        chapter_num=$(basename "$chapter")

        out_file="$out_dir/$template.$chapter_num.pdf"
        echo "$series_name-$chapter_num --> $out_file"

        convert "$chapter"/* $out_file
    done
done
