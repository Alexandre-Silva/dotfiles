#!/bin/zsh

packages=(
    "pm:emacs"
    "pm:aspell"{,-en,-pt}
    "pm:ttf-inconsolata"
    "pm:yapf"                 # Python style guide checker and formater
    "aur:global"              # GNU tags. Source code tag system (use it to query a tags databse)
    "aur:universal-ctags-git" # used to actually create tags database (alternative to GNU tags)

    # ycmd-layer
    "pm:clang-tools-extra"
    "pm:cmake"                # for ycmd
    "aur:libtinfo"            # undeclared dep for ycmd

    # realgud-package
    "pip:trepan3k"            # better python debugger
    "pip:xdis"                # undeclared dependency for trepan3k
)

links=(
    {"$DOTFILES/setups/emacs/",$HOME"/."}spacemacs
    /usr/share/gtags/gtags.conf $HOME/.globalrc
)

for l in ec et es; do
    links+=( {"$DOTFILES/setups/emacs/",$HOME"/.bin/"}$l )
done


function st_install() {
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

    _git_install Spacemacs "$HOME/.emacs.d/" "ssh://git@github.com/syl20bnr/spacemacs"

    local ycmd_home="$HOME/.local/share/ycmd"
    _git_install YCMD "$ycmd_home" "https://github.com/Valloric/ycmd"

    "$ycmd_home"/build.py --clang-completer
}

st_profile() {
    export YCMD_HOME="$HOME/.local/share/ycmd"
}
