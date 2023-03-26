return {
  {
    "telescope.nvim",
    dependencies = {
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        -- build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
        config = function()
          require("telescope").load_extension("fzf")
        end,
      },
      {
        "benfowler/telescope-luasnip.nvim",
        config = function()
          require("telescope").load_extension("luasnip")
        end,
      },
    },
      -- stylua: ignore
    keys = {
      { "<leader>sn", "<cmd>Telescope luasnip<cr>", desc = "snippets" },
    },
  },

  {
    "cbochs/grapple.nvim",
    requires = { "nvim-lua/plenary.nvim" },
    setup = function()
      require("grapple").setup({
        -- log_level = "debug",
        scope = require("grapple.scope").resolver(function()
          local root, _ = require("project_nvim.project").get_project_root()
          if root ~= nil then
            return root
          else
            return vim.fn.getcwd()
          end
        end, { cache = false, persist = false }),
      })
    end,

    keys = function()
      -- stylua: ignore
      local keys = {
        { "<leader>bm", function() require("grapple").toggle() end, "Grapple tag toggle", },
        { "<leader>b'", function() require("grapple").popup_tags() end, "Grapple poppup", },
      }

      for i = 1, 5, 1 do
        keys[#keys + 1] = {
          string.format("<A-%i>", i),
          function()
            require("grapple").select({ key = i })
          end,
          string.format("Grapple select %i", i),
        }
      end

      return keys
    end,
  },

  -- grapple in lualine
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections.lualine_x[#opts.sections.lualine_x + 1] = {
        function()
          local key = require("grapple").key()
          return " [" .. key .. "]"
        end,
        cond = function()
          local status_ok, grapple = pcall(require, "grapple")
          if not status_ok then
            return false
          end
          return grapple.exists()
        end,
      }
      return opts
    end,
  },
}
