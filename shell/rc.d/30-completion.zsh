### Indicates the package in wich the program can be found if not installed
try_source /usr/share/doc/pkgfile/command-not-found.zsh

# Workaround #
# Make zsh autocomplete respect dircolors.
# https://github.com/robbyrussell/oh-my-zsh/issues/1563
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}


### From ninrod dotfiles:
# https://github.com/ninrod/dotfiles/blob/master/zsh/completions.zsh
#########################

# case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

### fuzzy completion
# lifted from http://superuser.com/a/815317/555734
# 0 -- vanilla completion (abc => abc)
# 1 -- smart case completion (abc => Abc)
# 2 -- word flex completion (abc => A-big-Car)
# 3 -- full flex completion (abc => ABraCadabra)
zstyle ':completion:*' matcher-list '' \
       'm:{a-z\-}={A-Z\_}' \
       'r:[^[:alpha:]]||[[:alpha:]]=** r:|=* m:{a-z\-}={A-Z\_}' \
       'r:[[:ascii:]]||[[:ascii:]]=** r:|=* m:{a-z\-}={A-Z\_}'

# colors: magenta, green, blue,cyan, yellow, red
zstyle ':completion:*:functions' ignored-patterns '_*'
zstyle ':completion:*' format $'\n%F{yellow}Completing %d%f\n'
zstyle ':completion:*' group-name ''

### END ninrod completion
