
--
-- Add neogit
--
-- stylua: ignore

return {
  { "NeogitOrg/neogit",
    requires = 'nvim-lua/plenary.nvim',
    keys = { { "<leader>gg", function() require("neogit").open() end, desc = "Neogit Status" }, },
    config = function()
      local neogit = require('neogit')
      neogit.setup({
        -- Change the default way of opening neogit
        kind = "split",
        -- Change the default way of opening the commit popup
        commit_popup = {
          kind = "split",
        },
        -- Change the default way of opening popups
        popup = {
          kind = "split",
        },
        -- customize displayed signs
        signs = {
          -- { CLOSED, OPENED }
          section = { "▷ ", "▽ " },
          item = { "▷ ", "▽ " },
          hunk = { "", "" },
        },

        -- when nvim-noice is active, the confirmation breaks the plugin
        -- see https://github.com/folke/noice.nvim/issues/232
        disable_commit_confirmation = true,
      })
    end
  }
}
