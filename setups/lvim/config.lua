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
lvim.builtin.which_key.mappings["b"]["m"] = { require("grapple").toggle, "Anon tag toggle" }
lvim.builtin.which_key.mappings["b"]["'"] = { require("grapple").popup_tags, "Tags poppup" }
lvim.builtin.which_key.mappings["b"]["1"] = { function() require("grapple").select({ key = 1 }) end, "tag 1" }
lvim.builtin.which_key.mappings["b"]["2"] = { function() require("grapple").select({ key = 2 }) end, "tag 2" }
lvim.builtin.which_key.mappings["b"]["3"] = { function() require("grapple").select({ key = 3 }) end, "tag 3" }
lvim.builtin.which_key.mappings["b"]["4"] = { function() require("grapple").select({ key = 4 }) end, "tag 4" }
lvim.builtin.which_key.mappings["b"]["5"] = { function() require("grapple").select({ key = 5 }) end, "tag 5" }

lvim.builtin.which_key.mappings["s"]["w"] = { "<cmd>Telescope grep_string<cr>", "Word under cursor" }
lvim.builtin.which_key.mappings["s"]["s"] = { "<cmd>Telescope luasnip<cr>", "snippet" }
lvim.builtin.which_key.mappings["s"]["l"] = { "<cmd>Telescope resume<cr>", "last search" }

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
    cond = require("grapple").exists,
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


require('leap').add_default_mappings()

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

-- Strip Whitespace on file save
vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = "*",
  command = 'silent! StripWhitespaceOnChangedLines',
})
