packages=()

links=(
    "$HOME/.config/zvim" "$HOME/.config/nvim"
    "$ADM_DIR" $HOME/.config/zvim
    "$ADM_DIR"/autoflake-null-ls.sh $HOME/.bin/autoflake-null-ls.sh
)


st_rc() {
  if ! hash lvim &>/dev/null; then
    return
  fi

  alias zvim='nvim -u ~/.config/zvim/init.lua'
}
