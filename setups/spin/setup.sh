#!/usr/bin/bash

## NOTICE ##
# spinSpider related code comes from:
# https://code.google.com/archive/p/jspin/

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
