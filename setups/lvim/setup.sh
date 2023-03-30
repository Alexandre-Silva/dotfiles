packages=()

links=(
    "$ADM_DIR" $HOME/.config/lvim
    "$ADM_DIR"/autoflake-null-ls.sh $HOME/.bin/autoflake-null-ls.sh
)


st_rc() {
  if ! hash lvim &>/dev/null; then
    return
  fi

  # alias nvim='lvim'
}
