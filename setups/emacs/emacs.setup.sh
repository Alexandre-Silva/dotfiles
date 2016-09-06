#!/bin/zsh

packages=(
    "pm:emacs"
    "pm:aspell"{,-en,-pt}
    "pm:yapf" # Python style guide checker
    "pm:clang-tools-extra"
    "aur:libtinfo" # needed for ycmd
    "aur:global" # GNU tags. Source code tag system (use it to query a tags databse)
    "aur:universal-ctags-git" # used to actually create tags database (better than GNU tags)
)

links=(
    {"$DOTFILES/setups/emacs/",~"/."}spacemacs
    /usr/share/gtags/gtags.conf ~/.globalrc
)

for l in ec et es; do
    links+=( {"$DOTFILES/setups/emacs/",~"/.bin/"}$l )
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

    # Fix for ycmd/libtinfo wihch only provides soft links for libtinfo.so.6
    sudo ln --force --symbolic --verbose /usr/lib/libtinfo.so /usr/lib/libtinfo.so.5

    _git_install Spacemacs "$HOME/.emacs.d/" "ssh://git@github.com/syl20bnr/spacemacs"

    local ycmd_home="$HOME/.local/share/ycmd"
    _git_install YCMD "$ycmd_home" "https://github.com/Valloric/ycmd"

    "$ycmd_home"/build.py --clang-completer
}

st_profile() {
    export YCMD_HOME="$HOME/.local/share/ycmd"
}
