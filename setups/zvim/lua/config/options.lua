-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.o.background = "dark"
vim.g.gruvbox_material_background = "medium"

vim.opt.modeline = true

vim.g.autoformat = false


vim.filetype.add({
  filename = {
    ["play.yml"] = "yaml.ansible",
    ["play.yaml"] = "yaml.ansible",
    ["playbook.yml"] = "yaml.ansible",
    ["playbook.yaml"] = "yaml.ansible",
  },
})
