# dotfiles/shell/rc
# loads all files in dotfiles/shell/rc.d

[ -z $DOTFILES ] && printf "dotfiles/shell/rc\nvar DOTFILES is not defined" && return 1

# load all posis compatible files
for f in $DOTFILES"/shell/rc.d/"*.sh ; do
    source "${f}"
done


if [[ -n $ZSH_VERSION ]]; then
    for f in $DOTFILES"/shell/rc.d/"*.zsh ; do
        source "${f}"
    done
fi
