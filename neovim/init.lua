-- ==================================================
-- Core settings
-- Configure core editor behavior.
-- ==================================================

vim.opt.whichwrap = "b,s,[,],<,>,~"
vim.opt.mouse = ""

vim.opt.hlsearch = true
vim.opt.cursorline = true

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
-- Encoding
-- Configure preferred file encodings.
-- ==================================================

vim.opt.fileencodings = "utf-8,cp932,euc-jp"

-- ==================================================
-- Swap files
-- Store swap files outside working directories.
-- ==================================================

local swap_dir = vim.fn.expand("$HOME/.vim/swap")

if vim.fn.isdirectory(swap_dir) == 0 then
  vim.fn.mkdir(swap_dir, "p")
end

vim.opt.directory = swap_dir .. "//"

-- ==================================================
-- Undo history
-- Persist undo history outside working directories.
-- ==================================================

local undo_dir = vim.fn.expand("$HOME/.vim/undo")

if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")
end

vim.opt.undofile = true
vim.opt.undodir = undo_dir

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
