# dotfiles/shell/rc
# loads all files in dotfiles/shell/rc.d

[ -z $DOTFILES ] && printf "dotfiles/shell/rc\nvar DOTFILES is not defined" && exit

# for dependencies handling files in rc.d are loaded by 0-filenames.sh then 1-filenames.sh ...
# files which do not start with '[0-9]-' are loaded last

for level in {0..9}- ""; do
    for f in $(find $DOTFILES"/shell/rc.d" -type f -name $level"*.sh" ); do
        . $f
    done
done
