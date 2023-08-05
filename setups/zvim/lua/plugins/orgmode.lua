
--
-- Add nvim-orgmode
--
-- stylua: ignore

return {
  { "nvim-orgmode/orgmode",
    -- keys = { { "<leader>gg", function() require("neogit").open() end, desc = "Neogit Status" }, },
    ft = 'org',
    opts = {
      org_hide_leading_stars=true,
    },
  },
  {
  "nvim-treesitter/nvim-treesitter",
  opts = function(_, opts)
    if type(opts.ensure_installed) == "table" then
      require('orgmode').setup_ts_grammar()
      vim.list_extend(opts.ensure_installed, { "org" })
    end
  end,
}
}
