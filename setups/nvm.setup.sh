#!/usr/bin/bash

st_rc() {
    export NVM_DIR="${HOME}/.nvm"

    # lazy loads NVM
    nvm() {
        [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm
        nvm "$@"
    }
}
