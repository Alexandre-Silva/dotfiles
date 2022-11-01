_cd_save_pwd_count=0
# saves the last cd dir. Used with terminal launch
_cd_save_pwd() {
  if [[ "$PWD" != "$HOME" ]]; then
    print "$PWD" > /var/run/user/$UID/cd-last.txt
  fi
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _cd_save_pwd # in functions
