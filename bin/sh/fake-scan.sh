#!/bin/bash
#
# Make a pdf look like it was scanned.
#
# from HackerNews post: https://news.ycombinator.com/item?id=30027344
# "+noise Random -fill white -colorize 95%" to add some noise to the image
# "-distort ScaleRotateTranslate '$x,$y $angle'" to randomly shift horizontally and vertically the document, and randomly rotate it slightly
# "-density 150" for a low-ish resolution so it better hides the fact the PDF wasn't really scanned
# "-colorspace Gray" to make it black & white
# "-quality 60" to increase JPG compression and somewhat reduce picture quality

set -e

if [ $# -ne 2 ]; then
    echo "Usage: $0 input output" >&2
    exit 1
fi

tmp="$1".scanner-look.tmp
mkdir "$tmp" &&
    # without -flatten some PDF convert to a JPG with a black background
    convert -density 150 "$1" -colorspace Gray -quality 60 -flatten "$tmp"/p_in.jpg &&
    : || exit 1

# each page is randomly shifted in the X and Y plane.
# units seem to depend on angle of rotation in ScaleRotateTranslate?
offset() { echo $(($RANDOM % 1000)); }

for f in "$tmp"/p_in*jpg; do
    # each page is randomly rotated by [-0.5 .. 0.5[ degrees
    angle=$(python -c 'import random; print(random.random()-0.5)')
    x=$(offset)
    y=$(offset)
    convert "$f" \
            -blur 0x0.5 \
            -distort ScaleRotateTranslate "$x,$y $angle" +repage \
            \( +clone +noise Random -fill white -colorize 95% \) \
            -compose darken \
            -composite \
            ${f/p_in/p_out}.pdf || exit 1
done
# concatenate all the pages to one PDF
# use "ls -v" to order files correctly (p_out-X.jpg where X is 0 1 2 ... 9 10 11 ...)
pdftk $(ls -v "$tmp"/p_out*.pdf) cat output "$2" &&
    rm -rf "$tmp"
