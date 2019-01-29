#!/usr/bin/bash
set -euo pipefail
IFS=$'\n\t'

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

tmp=$(mktemp -d /tmp/manga-scapper.XXXXXX)
# tmp=/tmp/mangakakalot-scapper.APaxZW

# template="$1";shift
out_dir="$1";shift
python3 "$DIR/mangadex-scrapper.py" "$tmp" "$@"

for chapter in "$tmp/"* ; do
    chapter_name=$(basename "$chapter")

    out_file="$out_dir/$chapter_name.pdf"
    echo "$chapter_name --> $out_file"

    mkdir --parents "$(dirname "$out_file")"

    images=( "$chapter"/* )
    convert "${images[@]}" "$out_file"
done
