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
  { 'neovim/nvim-lspconfig' },
  {
    'nvim-treesitter/nvim-treesitter',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate'
  },
  {
    'nvim-telescope/telescope.nvim', tag='0.1.1',
    dependencies = { 'nvim-lua/plenary.nvim' },
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

--   lsp setup
require'lspconfig'.clangd.setup{
  cmd = {
    'clangd',
    '-header-insertion=never'
  }
}

--   treesitter setup
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c', 'cpp', 'lua' },
  highlight = { enable = true },
}

--   toggleterm setup
require("toggleterm").setup {
  size = 20,
  open_mapping = '<a-t>',
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

--   telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

--   toggleterm
--     compilation
function compile()
  local buf = vim.api.nvim_get_current_buf()
  local path = vim.api.nvim_buf_get_name(buf)
  if (vim.loop.os_uname().sysname == "Windows_NT") then
    path = string.gsub(path, "\\[^\\]*$", "\\build.bat")
    print(path)
    vim.api.nvim_command("TermExec cmd=cls")
  else
    path = string.gsub(path, "/[^/]*$", "/build.sh")
    vim.api.nvim_command("TermExec cmd=clear")
  end
  vim.api.nvim_command("TermExec cmd="..path)
end
vim.keymap.set('n', '<leader>c', compile)
--     toggle 
vim.keymap.set('t', '<esc>', '<c-\\><c-n>')

-- auto save folds
local folds = vim.api.nvim_create_augroup("remember_folds", { clear = true })
vim.api.nvim_create_autocmd("BufWinLeave", {
  command = "silent! mkview",
  group = folds,
})
vim.api.nvim_create_autocmd("BufWinEnter", {
  command = "silent! loadview",
  group = folds
})
