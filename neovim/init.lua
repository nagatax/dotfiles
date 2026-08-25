-- ~/.config/nvim/init.lua

------------------------------------------------------------
-- 基本設定
------------------------------------------------------------

vim.opt.whichwrap = "b,s,[,],<,>,~"
vim.opt.mouse = ""

vim.opt.hlsearch = true
vim.opt.cursorline = true

-- インデント
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true

-- 行番号
vim.opt.number = true

-- wildmenu
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,full"

-- 最終ステータスラインを常に表示
vim.opt.laststatus = 2


------------------------------------------------------------
-- encoding
------------------------------------------------------------

vim.opt.fileencodings = "utf-8,cp932,euc-jp"


------------------------------------------------------------
-- swap
------------------------------------------------------------

local swap_dir = vim.fn.expand("$HOME/.vim/swap")

if vim.fn.isdirectory(swap_dir) == 0 then
  vim.fn.mkdir(swap_dir, "p")
end

vim.opt.directory = swap_dir .. "//"


------------------------------------------------------------
-- undo
------------------------------------------------------------

local undo_dir = vim.fn.expand("$HOME/.vim/undo")

if vim.fn.isdirectory(undo_dir) == 0 then
  vim.fn.mkdir(undo_dir, "p")
end

vim.opt.undofile = true
vim.opt.undodir = undo_dir


------------------------------------------------------------
-- syntax
------------------------------------------------------------

vim.cmd("syntax enable")


------------------------------------------------------------
-- lazy.nvim
------------------------------------------------------------

require("config.lazy")


------------------------------------------------------------
-- 組み込みプラグイン
------------------------------------------------------------

vim.cmd.packadd("nvim.difftool")
