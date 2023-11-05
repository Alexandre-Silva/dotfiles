packages=(
	"pm:pyright"
	"pm:ruff"
	"pm:ruff-lsp"
	"pm:neovim"
	"pm:python-pynvim"
	"pm:shellcheck"
	"pm:shfmt"
)

links=(
	"$ADM_DIR" $HOME/.config/zvim
	"$HOME/.config/zvim" "$HOME/.config/nvim"
	"$ADM_DIR"/autoflake-null-ls.sh $HOME/.bin/autoflake-null-ls.sh
)

st_rc() {
	alias zvim='\nvim -u ~/.config/zvim/init.lua'
	alias nvim='zvim'
}
