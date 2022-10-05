--[[
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
lvim.log.level = "info"
lvim.format_on_save = false
lvim.colorscheme = "gruvbox-material"
vim.o.background = "dark"
vim.g.gruvbox_material_background = 'medium'

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
lvim.builtin.which_key.mappings["b"]["b"] = { "<cmd>Telescope buffers<cr>", "List Buffers" }

lvim.builtin.which_key.mappings["s"]["s"] = { "<cmd>Telescope grep_string<cr>", "Word under cursor" }
lvim.builtin.which_key.mappings["<tab>"] = { "<cmd>b#<CR>", "Previous buffer" }


-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.notify.active = true
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

-- LSP settings
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "yapf", filetypes = { "python" } },
  -- { command = "isort", filetypes = { "python" } },
}

lvim.plugins = {
  { "luisiacc/gruvbox-baby", branch = 'main' },
  { "sainnhe/gruvbox-material" },
}

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
