#!/usr/bin/bash

__FF_HOME=( ~/.mozilla/firefox/*.default )
if [ -e "${__FF_HOME}" ]; then
    packages=(
        "pm:firefox"
    )

    links=(
        "${ADM_DIR}/userChrome.css" "${__FF_HOME}/chrome/userChrome.css"
    )
fi
