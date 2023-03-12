--
-- Add colorscheme related pluins 
--
-- stylua: ignore

return {
  { "sainnhe/gruvbox-material" },
  
  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "gruvbox-material",
    },
  }
}
