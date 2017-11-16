#!/usr/bin/bash

packages=(
    "aur:spin"
)

links=(
    "${ADM_DIR}/spinspider" "${HOME}/.bin/spinspider"
)

st_install() {
    (
        cd "${ADM_DIR}/spinSpider"
        javac ./*.java
    )
}
