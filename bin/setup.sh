packages=()

links=( {"$DOTFILES/bin/python/",$HOME"/.bin/"}temp2speed.py )

find "$DOTFILES/bin/sh/" -type f -executable -print0 | while IFS= read -r -d '' file; do
    local link_name="$HOME/.bin/$(basename "$file")"

    links+=( "$file" "$link_name" )
done
