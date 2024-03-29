# Add help command
autoload -U run-help
autoload run-help-git
autoload run-help-svn
autoload run-help-svk
alias help=run-help


# zsh options
setopt AUTO_CD EXTENDED_GLOB
unsetopt share_history
unsetopt inc_append_history
# setopt +o nomatch # globs with no matches found doesn't turn to error
