#!/usr/env/env bash

packages=(
  "pm:python-requests"
  "pm:python-click"
  "pm:python-icalendar"
  "aur:python-pysimplegui"
)

links=()

while IFS= read -r -d '' file; do
    local link_name="$HOME/.bin/$(basename "$file")"

    links+=( "$file" "$link_name" )
done < <(find "$DOTFILES/bin/sh/" "$DOTFILES/bin/python/" -type f -executable -print0)


st_rc() {
	alias ntfy='ntfy.py'
}


function st_install() {
    if hash cargo &>/dev/null; then
        for app in "$DOTFILES/bin/rust/"*; do
            if [ -f "${app}/disable" ]; then
                continue
            fi

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
