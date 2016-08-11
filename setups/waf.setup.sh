packages=( )

links=(
    "$HOME/.local/src/waf/waf" "$HOME/.bin/waf"
)

st_install() {
    _git_install() {
        local name="$1"
        local target="$2"
        local url="$3"

        if [[ -d "$target" ]]; then
            echo "Updating $name"
            git -C "$target" pull

        else
            echo "Cloning $name"
            git clone "$url" "$target"
        fi

        git -C "$target" spull
    }

    local wlocal="$HOME/.local/src/waf"
    _git_install waf "$wlocal" "https://github.com/waf-project/waf"

    # build the waf bin
    builtin cd  "$wlocal"
    ./waf-light configure build
    builtin cd -
}

st_profile() {
    export WAFDIR="$HOME/.local/src/waf"
}
