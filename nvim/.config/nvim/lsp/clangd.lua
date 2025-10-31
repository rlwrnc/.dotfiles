return {
  cmd = { "clangd", "-header-insertion=never", "--enable-config" },
  root_markers = { ".clangd", "compile_commands.json" },
  filetypes = { "c", "cpp" }
}
