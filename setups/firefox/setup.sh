#!/usr/bin/bash

packages=(
    "pm:firefox"
)

adm_sh_setopt_push +nullglob

# Only sets the userChrome if the firefox profile exists
__FF_HOME=( ~/.mozilla/firefox/*.default )
if [ "${__FF_HOME}" != '~/.mozilla/firefox/*.default' ]; then
    links=(
        "${ADM_DIR}/userChrome.css" "${__FF_HOME}/chrome/userChrome.css"
    )
fi

adm_sh_setopt_pop
