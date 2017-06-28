packages=()

links=( {"$DOTFILES/bin/python/",$HOME"/.bin/"}temp2speed.py )

while IFS= read -r -d '' file; do
    local link_name="$HOME/.bin/$(basename "$file")"

    links+=( "$file" "$link_name" )
done < <(find "$DOTFILES/bin/sh/" -type f -executable -print0)


function st_install() {
    if hash cargo &>/dev/null; then
        for app in "$DOTFILES/bin/rust/"*; do
            (
                cd "${app}"
                cargo build --release
                local app_name="$(basename "${app}")"
                /bin/cp \
                    --verbose --force \
                    "${app}/target/release/${app_name}" \
                    "${HOME}/.bin/${app_name}"
            )
        done
    fi
}
