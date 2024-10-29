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
  { 'tpope/vim-abolish' },
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
  { 'tveskag/nvim-blame-line' },
  {
    'sainnhe/gruvbox-material',
    lazy = false,
    priority = 1000,
    config = function()
      vim.g.gruvbox_material_background = 'hard'
      vim.g.gruvbox_material_foreground = 'material'
      vim.opt.termguicolors = true
      vim.cmd.colorscheme('gruvbox-material')
    end
  },
  {
    'folke/todo-comments.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      signs = false,
      keywords = { 
        FIX = { icon = "#", color = "error", alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, },
        TODO = { icon = ">", color = "info" },
        HACK = { icon = "?", color = "warning" },
        WARN = { icon = "!", color = "warning", alt = { "WARNING", "XXX" } },
        PERF = { icon = ".", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
        NOTE = { icon = "i", color = "hint", alt = { "INFO" } },
        TEST = { icon = "T", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
      },
      highlight = {
        before = "",
        keyword = "bg",
        after = "",
        pattern = {
          [[.*(KEYWORDS)\s*:]],
          [[.*(KEYWORDS)(.*)\s*:]]
        },
      },
      search = {
        pattern = [[\b(KEYWORDS)(\(.*\))?:]]
      },
    }
  },
  {
    'stevearc/oil.nvim',
    opts = {
      view_options = {
        show_hidden = true
      }
    },
  }
})

-- set up plugins
--   mini setup
require('mini.basics').setup()
require('mini.comment').setup()
require('mini.completion').setup()
require('mini.cursorword').setup()
require('mini.fuzzy').setup()
require('mini.move').setup()
require('mini.pairs').setup()
require('mini.surround').setup()

--   lsp setup
require'lspconfig'.clangd.setup{
  cmd = {
    'clangd',
    '-header-insertion=never',
    '--enable-config'
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
        -- Get the language server to recognize the `vim` globals
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

require'lspconfig'.cmake.setup{}

require'lspconfig'.pyright.setup{
  settings = {
    pyright = {
      disableOrganizeImports = true,
    },
    python = {
      analysis = {
        ignore = { '*' },
      },
    },
  },
}

vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_hover', { clear = true }),
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client == nil then
      return
    end
    if client.name == 'ruff' then
      -- Disable hover in favor of Pyright
      client.server_capabilities.hoverProvider = false
    end
  end,
  desc = 'LSP: Disable hover capability from Ruff',
})

require'lspconfig'.ruff.setup{}

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
    vim.keymap.set('n', '<leader>fo', function()
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
vim.opt.clipboard = 'unnamedplus'

vim.opt.exrc = true
vim.opt.secure = true

-- buffer autoload
vim.api.nvim_create_autocmd({'FocusGained', 'BufEnter'}, {
  pattern = '*',
  command = 'silent! !'
})

vim.api.nvim_create_autocmd({'FocusLost', 'WinLeave'}, {
  pattern = '*',
  command = 'silent! noautocmd w'
})

vim.api.nvim_create_autocmd({'FileChangedShellPost'}, {
  pattern = '*',
  command = "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None",
})

-- keymaps
--   navigation
vim.keymap.set('n', '<c-h>', '<c-w>h')
vim.keymap.set('n', '<c-j>', '<c-w>j')
vim.keymap.set('n', '<c-k>', '<c-w>k')
vim.keymap.set('n', '<c-l>', '<c-w>l')

vim.keymap.set('n', '<c-u>', '<c-u>zz')
vim.keymap.set('n', '<c-d>', '<c-d>zz')

vim.keymap.set('n', '<leader>r', function()
  vim.o.relativenumber = not vim.o.relativenumber
end)

vim.keymap.set('n', '<leader>m', '<c-w>|')
vim.keymap.set('n', '<leader>=', '<c-w>=')

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
vim.keymap.set('n', '<leader>ft', '<CMD>TodoTelescope<CR>')

vim.keymap.set('n', '<leader>b', function() vim.api.nvim_command("make") end)

vim.keymap.set('n', '<leader>o', '<CMD>Oil<CR>')

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
