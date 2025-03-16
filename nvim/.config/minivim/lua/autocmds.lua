local reload = vim.api.nvim_create_augroup("AutoReload", {})

local function create_reload_autocmd(events, cmd)
  vim.api.nvim_create_autocmd(events, {
    pattern = "*",
    command = cmd,
    group = reload
  })
end

create_reload_autocmd({ "FocusGained", "WinLeave" }, "silent! !")
create_reload_autocmd({ "FocusGained", "WinLeave" }, "silent! noautocmd w")
create_reload_autocmd({ 'FileChangedShellPost' }, "echohl WarningMsg | echo 'File changed on disk. Buffer reloaded.' | echohl None")
