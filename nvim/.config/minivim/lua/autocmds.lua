local reload = vim.api.nvim_create_augroup("AutoReload", {})

local function create_reload_autocmd(events, cmd)
  vim.api.nvim_create_autocmd(events, {
    pattern = "*",
    command = cmd,
    group = reload
  })
end

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
    vim.keymap.set('n', '<space>n', vim.lsp.buf.rename, opts)
    vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>fo', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

create_reload_autocmd({ "FocusGained", "WinLeave" }, "silent! !")
create_reload_autocmd({ "FocusGained", "WinLeave" }, "silent! noautocmd w")
create_reload_autocmd({ 'FileChangedShellPost' }, "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None")
