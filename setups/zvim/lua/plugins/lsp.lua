return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- Automatically format on save
      autoformat = false,
      --
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        timeout_ms = 5000,
      },
    },
  },

  -- based on default settings for lazyvim
  {
    "nvimtools/none-ls.nvim",
    opts = function()
      local nls = require("null-ls")

      return {
        log_level = "info",

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
          nls.builtins.formatting.yapf.with({ timeout = 5000 }),
          nls.builtins.formatting.isort.with({ timeout = 5000 }),
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
          timeout = 5000,
        }),
      })
    end,
  },
}
