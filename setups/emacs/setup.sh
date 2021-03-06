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
    "pip:autoflake"           # RM unused imports and variables
    "pm:python-pylint"        # A Python source code analyzer which looks for
                              # programming errors, helps enforcing a coding
                              # standard and sniffs for some code smells
    "pm:python-jedi"          # Python Auto-complete related deps
    # "pip:json-rpc"
    # "pip:service_factory"
    "pm:python-pytest"{,-cov,-xdist} # PyTest module, coverage and parallel test plugin

    # ycmd-layer
    "pm:cmake"                # for ycmd
    "aur:vim-youcompleteme-git"

    # realgud-package
    "pip:trepan3k"            # better python debugger
    "pip:xdis"                # undeclared dependency for trepan3k

    # javascript
    "npm:tern"                # auto-complete
    "npm:js-beautify"         # code formatter
    "npm:eslint"              # linter
)

links=(
    {"$DOTFILES/setups/emacs/","$HOME/."}spacemacs
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
}

st_profile() {
    export YCMD_HOME="/usr/share/vim/vimfiles/third_party/ycmd"
}
