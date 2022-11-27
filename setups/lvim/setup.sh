packages=()

links=(
    "$ADM_DIR"/config.lua $HOME/.config/lvim/config.lua
    "$ADM_DIR"/luasnippets $HOME/.config/lvim/luasnippets
    "$ADM_DIR"/autoflake-null-ls.sh $HOME/.bin/autoflake-null-ls.sh
)


st_rc() {
  if ! hash lvim &>/dev/null; then
    return
  fi

  alias nvim='lvim'
}
