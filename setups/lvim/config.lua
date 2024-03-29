--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]

-- IMPORTS
local nl = require("null-ls")
local nlh = require("null-ls.helpers")
local nll = require("null-ls.loop")
local nlu = require("null-ls.utils")
local FORMATTING = nl.methods.FORMATTING
local CODE_ACTION = nl.methods.CODE_ACTION
local formatters = require "lvim.lsp.null-ls.formatters"
local Log = require "lvim.core.log"
local fmt = string.format
local ls = require('luasnip')
local wk = require("which-key")

-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT


-- general
lvim.log.level = "info"
lvim.format_on_save = false
lvim.colorscheme = "gruvbox-material"
vim.o.background = "dark"
vim.g.gruvbox_material_background = 'medium'

-- show relative line numbers except for current one
vim.o.relativenumber = true
vim.o.number = true

-- to disable icons and use a minimalist setup, uncomment the following
-- lvim.use_icons = false


-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.keys.normal_mode["<C-l>"] = ":noh<cr>"
-- lvim.keys.normal_mode["<S-l>"] = ":BufferLineCycleNext<CR>"
-- lvim.keys.normal_mode["<S-h>"] = ":BufferLineCyclePrev<CR>"
-- unmap a default keymapping
-- vim.keymap.del("n", "<C-Up>")
-- override a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>" -- or vim.keymap.set("n", "<C-q>", ":q<cr>" )


local cmp = require('cmp')
local keymap = require('cmp.utils.keymap')

-- NOTE: cmp related keymaps are repeated for 'lvim.builtin.cmp.mapping' and 'vim.keymap' because
-- the former overrides the latter when the completion hover (from nvim-cmp) appears.
-- Thus, this is needed to keep the keymaps consistent
local cmd_keyset = function(modes, key, fn)
  local keyn = keymap.normalize(key)
  lvim.builtin.cmp.mapping[keyn] = cmp.mapping(fn, modes)
  -- cmp.mapping[key] = cmp.mapping(fn, modes)
  vim.keymap.set(modes, keyn, fn, { silent = true })
end

cmd_keyset({ "i", "s" }, "<C-K>", function(fallback)
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  elseif fallback ~= nil then
    fallback()
  end
end)

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- we use protected-mode (pcall) just in case the plugin wasn't loaded yet.
-- local _, actions = pcall(require, "telescope.actions")
-- lvim.builtin.telescope.defaults.mappings = {
--   -- for input mode
--   i = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--     ["<C-n>"] = actions.cycle_history_next,
--     ["<C-p>"] = actions.cycle_history_prev,
--   },
--   -- for normal mode
--   n = {
--     ["<C-j>"] = actions.move_selection_next,
--     ["<C-k>"] = actions.move_selection_previous,
--   },
-- }

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
-- lvim.builtin.which_key.mappings["t"] = {
--   name = "+Trouble",
--   r = { "<cmd>Trouble lsp_references<cr>", "References" },
--   f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
--   d = { "<cmd>Trouble document_diagnostics<cr>", "Diagnostics" },
--   q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
--   l = { "<cmd>Trouble loclist<cr>", "LocationList" },
--   w = { "<cmd>Trouble workspace_diagnostics<cr>", "Wordkpace Diagnostics" },
-- }
lvim.builtin.telescope.defaults.file_ignore_patterns = { "node_modules", ".git", "__pycache__" }


-- bindings for folds, spelling and others prefixed with z
lvim.builtin.which_key.setup.plugins.presets.z = true

local new_file_here = function()
  --local out = vim.fn.input('test>')
  local f = vim.api.nvim_buf_get_name(0)
  local dir = vim.fn.fnamemodify(f, ':h') .. '/'
  local input = vim.fn.input('save as: ', dir, 'file')
  if vim.fn.empty(input) == 1 then
    print('Cancelled')
    return
  end

  vim.fn.writefile({}, input, 'a')
  vim.cmd('edit ' .. input)

  -- print(vim.api.nvim_buf_get_name(0))
  -- local out = vim.fn.input('test>')
  -- print('\n' .. out)
end

-- buffers
lvim.builtin.which_key.mappings["b"]["d"] = { "<cmd>BufferKill<CR>", "Delete Buffer" }
lvim.builtin.which_key.mappings["b"]["n"] = { "<cmd>tabnew<CR>", "New Empty Buffer" }
lvim.builtin.which_key.mappings["b"]["N"] = { new_file_here, "New File here" }
lvim.builtin.which_key.mappings["b"]["Y"] = { "<cmd>%y+<CR>", "Yank buffer" }
lvim.builtin.which_key.mappings["b"]["b"] = { "<cmd>Telescope buffers<cr>", "List Buffers" }
lvim.builtin.which_key.mappings["b"]["m"] = { function() require("grapple").toggle() end, "Anon tag toggle" }
lvim.builtin.which_key.mappings["b"]["'"] = { function() require("grapple").popup_tags() end, "Tags poppup" }
for i = 1, 5, 1 do
  local name = string.format("tag %i", i)
  local key = string.format("%i", i)
  lvim.builtin.which_key.mappings["b"][key] = { function() require("grapple").select({ key = i }) end, name }
  lvim.builtin.which_key.mappings[key] = { function() require("grapple").select({ key = i }) end, name }
end

lvim.builtin.which_key.mappings["s"]["w"] = { "<cmd>Telescope grep_string<cr>", "Word under cursor" }
lvim.builtin.which_key.mappings["s"]["s"] = { "<cmd>Telescope luasnip<cr>", "snippet" }
lvim.builtin.which_key.mappings["s"]["l"] = { "<cmd>Telescope resume<cr>", "last search" }

lvim.builtin.which_key.mappings["g"]["g"] = { function() require("neogit").open() end, "Neogit Status" }

lvim.builtin.which_key.mappings["<tab>"] = { "<cmd>b#<CR>", "Previous buffer" }

lvim.builtin.which_key.mappings["l"]["f"] = {
  function()
    require("lvim.lsp.utils").format { timeout_ms = 2000 }
  end,
  "Format",
}

-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true

local function telescope_find_files(_)
  require("lvim.core.nvimtree").start_telescope "find_files"
end

local function telescope_live_grep(_)
  require("lvim.core.nvimtree").start_telescope "live_grep"
end

lvim.builtin.nvimtree.setup.view.side = "right"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false
lvim.builtin.nvimtree.setup.view.mappings.list = {
  -- original lunarvim additions
  { key = { "l", "<CR>", "o" }, action = "edit", mode = "n" },
  { key = "h", action = "close_node" },
  { key = "v", action = "vsplit" },
  { key = "C", action = "cd" },
  { key = "gtf", action = "telescope_find_files", action_cb = telescope_find_files },
  { key = "gtg", action = "telescope_live_grep", action_cb = telescope_live_grep },

  -- my additions
  { key = "?", action = "toggle_help" },
}

-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "cpp",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true


local lls = require("lvim.core.lualine.styles")
local lls_default = lls.get_style("default")
local lualine_x = {
  {
    function()
      local key = require("grapple").key()
      return " [" .. key .. "]"
    end,
    cond = function()
      local status_ok, grapple = pcall(require, "grapple")
      if not status_ok then return false end
      return grapple.exists()
    end,
  },
}
table.foreach(lls_default.sections.lualine_x, function(k, v) table.insert(lualine_x, v) end)

lvim.builtin.lualine.sections.lualine_x = lualine_x

-- LSP settings

formatters.setup {
  { command = "yapf" },
  { command = "isort", filetypes = { "python" } },
}

nl.register({
  name = "autoflake",
  -- method = FORMATTING,
  method = CODE_ACTION,
  filetypes = { "python" },

  generator = nlh.generator_factory({
    command = 'autoflake',
    args = { "--check", '--remove-all-unused-imports', "$FILENAME" },
    format = 'raw',
    check_exit_code = function(code)
      return code <= 1
    end,
    on_output = function(params, done)
      if params.output == 'No issues detected!\n' then
        return {}
      end

      local actions = {};
      table.insert(actions, {
        title = 'Remove unused imports',
        action = function()

          local get_content = function()
            -- when possible, get content from params
            if params.content then
              return nlu.join_at_newline(params.bufnr, params.content)
            end

            -- otherwise, get content directly
            return nlu.buf.content(params.bufnr, true) --[[@as string]]
          end

          local on_done = function(error_output, output)
            -- normalize line endings
            output = output:gsub("\r\n?", "\n")
            local lines = vim.split(output, "\n")
            vim.api.nvim_buf_set_lines(
              params.bufnr,
              0,
              -1,
              true,
              lines
            )
          end

          nll.spawn(
            "autoflake-null-ls.sh",
            { '--remove-all-unused-imports', },
            { handler = on_done, input = get_content() }
          )
        end,
      })

      done(actions)
    end,
  }),
})

lvim.plugins = {
  { "luisiacc/gruvbox-baby", branch = 'main' },
  { "sainnhe/gruvbox-material" },
  { "ntpeters/vim-better-whitespace" },
  { "benfowler/telescope-luasnip.nvim", module = "telescope._extensions.luasnip" },
  { "ggandor/leap.nvim" },
  { "tpope/vim-abolish" },
  { "nvim-telescope/telescope-fzf-native.nvim",
    run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
    -- run = "make",
    -- event = "BufRead",
  },
  { "nvim-treesitter/playground" },
  { "cbochs/grapple.nvim",
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
        end, { cache = false, persist = false })
      })
    end
  },
  { 'TimUntersberger/neogit',
    requires = 'nvim-lua/plenary.nvim',
    setup = function()
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
  },
  {
    "nvim-neorg/neorg",
    config = function()
      require('neorg').setup {
        load = {
          ["core.defaults"] = {}, -- Loads default behaviour
          ["core.norg.concealer"] = {}, -- Adds pretty icons to your documents
          ["core.norg.dirman"] = { -- Manages Neorg workspaces
            config = {
              workspaces = {
                notes = "~/Documents/@sync/syncthing/norg",
              },
            },
          },
          ["core.keybinds"] = {
            config = {
              default_keybinds = true,
              hook = function(keybinds)

                -- Binds the `gtd` key in `norg` mode to execute `:echo 'Hello'`
                keybinds.map_event("norg", "n", "td", "core.norg.qol.todo_items.todo.task_done")
                keybinds.map_event("norg", "n", "ti", "core.norg.qol.todo_items.todo.task_important")
                keybinds.map_event("norg", "n", "<leader>np", "core.norg.dirman.new.note")

                keybinds.map("norg", "n", "ta", "<cmd>Neorg keybind norg core.norg.qol.todo_items.todo.task_done <CR>")
                keybinds.map("norg", "n", "te", "<cmd>echo '321' <CR>")

              end,
            }
          }
        },
      }
    end,
    run = ":Neorg sync-parsers",
    requires = "nvim-lua/plenary.nvim",
  }
}

lvim.builtin.telescope.on_config_done = function(telescope)
  local installed_ls, _ = pcall(require, 'telescope._extensions.luasnip')
  if installed_ls then
    telescope.load_extension('luasnip')
  end

  -- NOTE: no need to call it. lunarvim already does it
  -- require('telescope').load_extension('fzf')
end


local leap_exists, leap = pcall(require, "leap")
if leap_exists then
  leap.add_default_mappings()
end

-- Autocommands (https://neovim.io/doc/user/autocmd.html)
-- vim.api.nvim_create_autocmd("BufEnter", {
--   pattern = { "*.json", "*.jsonc" },
--   -- enable wrap mode for json files only
--   command = "setlocal wrap",
-- })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "zsh",
--   callback = function()
--     -- let treesitter use bash highlight for zsh files as well
--     require("nvim-treesitter.highlight").attach(0, "bash")
--   end,
-- })


-- Detects jinj2
vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead' }, {
  pattern = "*.j2.html",
  command = 'set filetype=htmldjango',
})

-- Strip Whitespace on file save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = "*",
  command = 'silent! StripWhitespaceOnChangedLines',
})


-----------------
-- Neorg stuff --
-----------------
local neorg = require("neorg")
require("neorg.modules.base")

-- proper binds
vim.api.nvim_create_autocmd('BufEnter', {
  pattern = "*.norg",
  callback = function(ev)
    wk.register({
      -- ["ti"] = { function() require("neorg").core.norg.qol.todo_items.todo.task_important() end, 'Important' },
      -- ["td"] = { function() print(vim.inspect(neorg.modules.loaded_modules["core.norg.qol.todo_items"].public)) end, 'debug' },
    })
  end
})

---------------------
-- modular configs --
---------------------

local als = require ('alex.luasnip')
