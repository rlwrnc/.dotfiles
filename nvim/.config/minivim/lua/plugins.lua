-- mini
local path_package = vim.fn.stdpath('data') .. '/site'
local mini_path = path_package .. '/pack/deps/start/mini.nvim'
if not vim.loop.fs_stat(mini_path) then
  vim.cmd('echo "Installing `mini.nvim`" | redraw')
  local clone_cmd = {
    'git', 'clone', '--filter=blob:none',
    'https://github.com/echasnovski/mini.nvim', mini_path
  }
  vim.fn.system(clone_cmd)
  vim.cmd('packadd mini.nvim | helptags ALL')
  vim.cmd('echo "`mini.nvim` installed!" | redraw')
end

require("mini.basics").setup()
require("mini.comment").setup()
require("mini.completion").setup()
require("mini.cursorword").setup()
require("mini.fuzzy").setup()
require("mini.move").setup()
require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.pick").setup()
require("mini.files").setup()
require("mini.deps").setup({ path = { package = path_package } })

local add = MiniDeps.add

-- colors
add("sainnhe/gruvbox-material")
vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_foreground = 'material'
vim.opt.termguicolors = true
vim.cmd.colorscheme('gruvbox-material')

-- lspconfig
add("neovim/nvim-lspconfig")
local lspconfig = require("lspconfig")

local language_servers = { "clangd", "pyright", "ruff", "cmake" }
for _, server in ipairs(language_servers) do
  lspconfig[server].setup{}
end

-- treesitter
add({
  source = 'nvim-treesitter/nvim-treesitter',
  checkout = 'master',
  monitor = 'main',
  hooks = { post_checkout = function() vim.cmd('TSUpdate') end },
})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "c", "cpp", "lua", "python" },
  highlight = { enable = true },
  indent = { enable = true }
})

-- auto-detect indentation
add("NMAC427/guess-indent.nvim")
require("guess-indent").setup({ auto_cmd = true })

-- gives :Subvert
add("tpope/vim-abolish")
