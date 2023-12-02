-- vim.print(vim.diagnostic.config())
-- m.print(vim.diagnostic.config({virtual_text=false}))

local M = { virtual_text = nil }

return {
  {
    "neovim/nvim-lspconfig",
    keys = {
      {
        "<leader>uv",
        function()
          if not M.virtual_text then
            M.virtual_text = vim.diagnostic.config().virtual_text
          end

          if vim.diagnostic.config().virtual_text then
            vim.diagnostic.config({ virtual_text = false })
          else
            vim.diagnostic.config({ virtual_text = M.virtual_text })
          end
        end,
        desc = "Toggle Diagnostics virtual text",
      },
    },
  },
}
