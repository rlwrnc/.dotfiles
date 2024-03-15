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
  { 'tpope/vim-fugitive' },
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
    'nvim-telescope/telescope.nvim', branch='0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  { 'lewis6991/gitsigns.nvim' },
  { 'tveskag/nvim-blame-line' }
})

local palettes = {
  tomorrow_night = {
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
  solarized = {
    base00 = "#002b36",
    base01 = "#073642",
    base02 = "#33515b",
    base03 = "#586e75",
    base04 = "#657b83",
    base05 = "#839496",
    base06 = "#93a1a1",
    base07 = "#fdf6e3",
    base08 = "#dc322f",
    base09 = "#cb4b16",
    base0A = "#b58900",
    base0B = "#859900",
    base0C = "#2aa198",
    base0D = "#268bd2",
    base0E = "#6c71c4",
    base0F = "#d33682",
  },
  gruvbox_pale = {
    base00 = "#262626",
    base01 = "#3a3a3a",
    base02 = "#4e4e4e",
    base03 = "#8a8a8a",
    base04 = "#949494",
    base05 = "#dab997",
    base06 = "#d5c4a1",
    base07 = "#ebdbb2",
    base08 = "#d75f5f",
    base09 = "#ff8700",
    base0A = "#ffaf00",
    base0B = "#afaf00",
    base0C = "#85ad85",
    base0D = "#83adad",
    base0E = "#d485ad",
    base0F = "#d65d0e",
  }
}

-- set up plugins
--   mini setup
require('mini.base16').setup({
  palette = palettes['gruvbox_pale']
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

require'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },
}

require'lspconfig'.ols.setup{}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('rlwrnc', {}),
  callback = function(ev)
    local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<space>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<space>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

--   treesitter setup
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'c', 'cpp', 'lua' },
  highlight = { enable = true },
  indent = { enable = true }
}

require('gitsigns').setup()

-- options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.autoread = true
vim.opt.clipboard = 'unnamedplus'

-- keymaps
--   navigation
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')

vim.keymap.set('n', '<c-u>', '<c-u>zz')
vim.keymap.set('n', '<c-d>', '<c-d>zz')

--   git 
vim.keymap.set('n', '<leader>gb', function() vim.api.nvim_command("SingleBlameLine") end)
vim.keymap.set('n', '<leader>gs', '<CMD>Git status<CR>')
vim.keymap.set('n', '<leader>gc', '<CMD>Git commit<CR>')
vim.keymap.set('n', '<leader>ga', '<CMD>Gwrite<CR>')
vim.keymap.set('n', '<leader>gd', '<CMD>Gvdiffsplit<CR>')

--   tab for autocompletion
vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { expr = true })
vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })

--   telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

vim.keymap.set('n', '<leader>b', function() vim.api.nvim_command("make") end)

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

-- set c-style indenting for unrecognized c-like langs
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = {"*.odin", "*.glsl"},
  command = "setlocal cindent",
})

if vim.g.neovide then
  vim.o.guifont = "DroidSansM Nerd Font Mono:h16"
  vim.g.neovide_refresh_rate = 165
  vim.g.neovide_cursor_animation_length = 0.0
  vim.g.neovide_cursor_trail_size = 0.25
end
