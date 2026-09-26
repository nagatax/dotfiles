-- Copied from nvim-lspconfig (046b1a79, Apache-2.0): https://github.com/neovim/nvim-lspconfig/blob/046b1a79/lsp/phpantom_lsp.lua
---@brief
---
--- https://github.com/AJenbo/phpantom_lsp
---
--- Installation: https://github.com/AJenbo/phpantom_lsp/blob/main/docs/SETUP.md

---@type vim.lsp.Config
return {
  cmd = { 'phpantom_lsp' },
  filetypes = { 'php', 'blade' },
  root_markers = { '.phpantom.toml', '.git', 'composer.json' },
}
