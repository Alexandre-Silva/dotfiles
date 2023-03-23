
--
-- Add neogit
--
-- stylua: ignore

return {
  { "TimUntersberger/neogit",
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
      })
    end
  }
}
