return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        -- python = { "autoflake", "isort", "yapf" },
        -- python = { "autoflake", "ruff", "yapf" },
        python = { "isort", "ruff", "yapf" },
      },
      formatters = {
        autoflake = {
          args = { "--remove-all-unused-imports", "--stdin-display-name", "$FILENAME", "-" },
        },
      },
    },
  },
}
