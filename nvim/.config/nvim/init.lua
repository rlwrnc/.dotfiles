-- custom nonsense
function compile()
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(buf)
  path = string.gsub(path, "/[^/]*$", "/build.sh")
  vim.api.nvim_command("TermExec cmd="..path)
end

-- map leader key
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- bootstrap lazy.nvim
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system {
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  }
end
vim.opt.rtp:prepend(lazypath)

-- install plugins
require('lazy').setup({
  { 'tpope/vim-sleuth' },
  { 'echasnovski/mini.nvim', version = false },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate'
  },
  { 'akinsho/toggleterm.nvim', version = '*', config = true }
})

-- set up plugins
--   mini setup
require('mini.base16').setup({
  palette = {
    base00 = "#181818",
    base01 = "#282828",
    base02 = "#383838",
    base03 = "#585858",
    base04 = "#b8b8b8",
    base05 = "#d8d8d8",
    base06 = "#e8e8e8",
    base07 = "#f8f8f8",
    base08 = "#ab4642",
    base09 = "#dc9656",
    base0A = "#f7ca88",
    base0B = "#a1b56c",
    base0C = "#86c1b9",
    base0D = "#7cafc2",
    base0E = "#ba8baf",
    base0F = "#a16946",
  },
})
require('mini.basics').setup()
require('mini.comment').setup()
require('mini.completion').setup()
require('mini.cursorword').setup()
require('mini.fuzzy').setup()
require('mini.move').setup()
require('mini.pairs').setup()
require('mini.statusline').setup()
require('mini.surround').setup()

--   treesitter setup
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c', 'cpp', 'lua' },
  highlight = { enable = true },
}

--   toggleterm setup
require("toggleterm").setup {
  size = 20,
  open_mapping = '<leader>t',
  insert_mappings = false
}

-- options
vim.opt.relativenumber = true

-- keymaps
--   navigation
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')

--   tab for autocompletion
vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { expr = true })
vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

--   toggleterm
vim.keymap.set('n', '<leader>c', compile)
vim.keymap.set('t', '<esc>', '<c-\\><c-n>')
