return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Automatically format on save
      autoformat = false,
    },
  },

  -- based on default settings for lazyvim
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function()
      local nls = require("null-ls")

      return {
        log_level = "debug",

        -- defaults
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),

        sources = {
          -- defaults
          nls.builtins.formatting.fish_indent,
          nls.builtins.diagnostics.fish,
          nls.builtins.formatting.stylua,
          nls.builtins.formatting.shfmt,
          nls.builtins.diagnostics.flake8,

          -- python
          nls.builtins.formatting.yapf,
          nls.builtins.formatting.isort.with({ timeout = 2000 }),
          -- autoflake-alex is loaded in config()
        },
      }
    end,

    config = function(_, opts)
      local h = require("null-ls.helpers")
      local nls = require("null-ls")
      local methods = require("null-ls.methods")

      local FORMATTING = methods.internal.FORMATTING

      nls.setup(opts)

      nls.register({
        name = "autoflake-alex",
        method = { FORMATTING },
        filetypes = { "python" },
        generator = h.formatter_factory({
          command = "autoflake-null-ls.sh",
          args = { "--remove-all-unused-imports" },
          to_stdin = true,
          timeout = 2000,
        }),
      })
    end,
  },
}
