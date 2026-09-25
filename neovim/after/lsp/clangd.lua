return {
  cmd = {
    "clangd",
    "--background-index",
    -- Keep background indexing from competing with interactive requests.
    "--background-index-priority=low",
  },

  filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
  },

  root_markers = {
    "compile_commands.json",
    "compile_flags.txt",
    ".clangd",
    ".git",
  },
}
