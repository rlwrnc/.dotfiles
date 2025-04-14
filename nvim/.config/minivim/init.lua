vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("options")  -- set vim options
require("plugins")  -- plugin installation and configuration
require("keymaps")  -- set keymaps
require("autocmds") -- setup autocmds

if vim.g.neovide then
  vim.o.guifont = "DroidSansM Nerd Font Mono:h16"
  vim.g.neovide_refresh_rate = 165
  vim.g.neovide_cursor_animation_length = 0.0
  vim.g.neovide_cursor_trail_size = 0.25
end
