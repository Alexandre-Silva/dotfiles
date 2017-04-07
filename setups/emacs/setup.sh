#!/bin/zsh

packages=(
    "pm:emacs"
    "pm:aspell"{,-en,-pt}
    "pm:ttf-inconsolata"
    "aur:global"              # GNU tags. Source code tag system (use it to query a tags databse)
    "aur:universal-ctags-git" # used to actually create tags database (alternative to GNU tags)

    # python
    "pm:yapf"                 # Python style guide checker and formater
    "pip:mypy"                # Python static type checker
    "pm:python-pylint"        # A Python source code analyzer which looks for
                              # programming errors, helps enforcing a coding
                              # standard and sniffs for some code smells
    "pip:jedi"                # Python Auto-complete
    "pip:json-rpc"            #                      related
    "pip:service_factory"     #                              deps

    # ycmd-layer
    "pm:clang-tools-extra"
    "pm:cmake"                # for ycmd
    "aur:libtinfo"            # undeclared dep for ycmd

    # realgud-package
    "pip:trepan3k"            # better python debugger
    "pip:xdis"                # undeclared dependency for trepan3k

    # javascript
    "npm:tern"                # auto-complete
    "npm:js-beautify"         # code formatter
    "npm:eslint"              # linter
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

    # ycmd depends in libtinfo.so.5 but in ArchLinux it does not exist
    if [[ ! -f /usr/lib/libtinfo.so.5 ]]; then
        sudo ln --symbolic --relative  --verbose /usr/lib/libtinfo.so.{6,5}
    fi
}

st_profile() {
    export YCMD_HOME="$HOME/.local/share/ycmd"
}
