function github(repo)
  return "https://github.com/" .. repo
end

vim.pack.add({
  github("nvim-mini/mini.nvim"),
  github("sainnhe/gruvbox-material"),
  github("neovim/nvim-lspconfig"),
  github("NMAC427/guess-indent.nvim"),
  github("tpope/vim-abolish"),

  {
    src = github("nvim-treesitter/nvim-treesitter"),
    version = "main"
  },
})

-- colors
vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_foreground = 'material'
vim.opt.termguicolors = true
vim.cmd.colorscheme('gruvbox-material')

-- mini modules
mini_modules = {
  "basics", "icons", "statusline", "comment", "completion", "cursorword",
  "fuzzy", "move", "pairs", "surround", "pick", "files", "diff"
}

for _, mod in ipairs(mini_modules) do
  require("mini.".. mod).setup()
end

-- language servers
local language_servers = { "clangd", "pyright", "ruff", "cmake" }
for _, server in ipairs(language_servers) do
  vim.lsp.enable(server)
end

-- treesitter
ts_filetypes = {"c", "cpp", "lua", "python"}
require("nvim-treesitter").install(ts_filetypes)
vim.api.nvim_create_autocmd("FileType", {
  pattern = ts_filetypes,
  callback = function() vim.treesitter.start() end,
})

-- auto-detect indentation
require("guess-indent").setup({ auto_cmd = true })
