-- ==================================================
-- Core settings
-- Configure core editor behavior.
-- ==================================================

vim.opt.whichwrap = "b,s,[,],<,>,~"
vim.opt.mouse = ""

vim.opt.hlsearch = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.scrolloff = 4

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.confirm = true

-- Configure indentation behavior.
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true

vim.opt.number = true

-- Configure command-line completion behavior.
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,full"

vim.opt.laststatus = 2

-- ==================================================
-- File types
-- Configure additional file type detection.
-- ==================================================

vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
  },
})

-- ==================================================
-- Encoding
-- Configure preferred file encodings.
-- ==================================================

vim.opt.fileencodings = "utf-8,cp932,euc-jp"

-- ==================================================
-- Undo history
-- Persist undo history in Neovim's default state directory.
-- ==================================================

vim.opt.undofile = true

-- ==================================================
-- Syntax highlighting
-- Enable built-in syntax highlighting.
-- ==================================================

vim.cmd("syntax enable")

-- ==================================================
-- Plugin manager
-- Load the lazy.nvim plugin configuration.
-- ==================================================

require("config.lazy")

-- ==================================================
-- Built-in plugins
-- Load optional plugins distributed with Neovim.
-- ==================================================

vim.cmd.packadd("nvim.difftool")
