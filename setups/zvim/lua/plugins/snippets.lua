return {
  {
    "L3MON4D3/LuaSnip",
    config = function(_, opts)
      require('luasnip').setup(opts)
      require("luasnip.loaders.from_lua").load({ paths = "~/.config/zvim/snippets" })
    end,
  },
}
