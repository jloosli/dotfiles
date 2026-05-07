-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

local opt = vim.opt

opt.relativenumber = true       -- relative line numbers
opt.scrolloff = 8               -- keep cursor centered-ish
opt.tabstop = 4                 -- 4-space tabs
opt.shiftwidth = 4
opt.undofile = true             -- persistent undo across sessions
opt.updatetime = 250            -- faster git signs / diagnostics
opt.list = true                 -- show trailing whitespace
opt.listchars = { tab = "→ ", trail = "·", nbsp = "␣" }
