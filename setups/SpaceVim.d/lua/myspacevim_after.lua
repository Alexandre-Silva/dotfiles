
-- My custom Auto Commands Group
local aug = vim.api.nvim_create_augroup("MyAUG", {clear = true})

-- Strip Whitespace on file save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = aug,
  pattern = "*",
  command = [[ silent! StripWhitespace ]],
})


-- Makefile configs
vim.api.nvim_create_autocmd('Filetype', {
  group = aug,
  pattern = "make",
  command = [[ setlocal tabstop=4 ]],
})
