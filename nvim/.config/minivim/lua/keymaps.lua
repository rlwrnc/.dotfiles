local setmap = vim.keymap.set

-- mini.pick
setmap("n", "<leader>ff", MiniPick.builtin.files)
setmap("n", "<leader>fg", MiniPick.builtin.grep_live)

-- mini.files
setmap("n", "<leader>o", function()
  if not MiniFiles.close() then MiniFiles.open(vim.api.nvim_buf_get_name(0), false) end
end)

-- window navigation
setmap('n', '<c-h>', '<c-w>h')
setmap('n', '<c-j>', '<c-w>j')
setmap('n', '<c-k>', '<c-w>k')
setmap('n', '<c-l>', '<c-w>l')

-- page jumps
setmap("n", "<c-u>", "<c-u>zz")
setmap("n", "<c-d>", "<c-d>zz")

-- relative line number toggle
setmap("n", "<leader>l", function()
  vim.o.relativenumber = not vim.o.relativenumber
end)

-- pane maximize/restore
setmap("n", "<leader>m", "<c-w>|")
setmap("n", "<leader>r", "<c-w>=")

setmap("n", "<leader>b", function() vim.api.nvim_command("make!") end)

setmap("n", "<leader>dv", function() vim.diagnostic.open_float() end)
