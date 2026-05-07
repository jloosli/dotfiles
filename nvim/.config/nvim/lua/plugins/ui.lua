-- UI improvements
return {
  -- Colorscheme: catppuccin (great for eyes, works well with LazyVim)
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = { flavour = "mocha" },
  },

  -- Set it as the default colorscheme
  {
    "LazyVim/LazyVim",
    opts = { colorscheme = "catppuccin" },
  },
}
