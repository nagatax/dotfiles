-- ==================================================
-- Providers
-- Disable unused remote-plugin providers.
-- ==================================================

vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- ==================================================
-- Core settings
-- Configure core editor behavior.
-- ==================================================

vim.opt.whichwrap = "b,s,[,],<,>,~"
vim.opt.mouse = ""
vim.opt.clipboard = "unnamedplus"

vim.opt.hlsearch = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "screenline,number"
vim.opt.signcolumn = "yes"
vim.opt.foldcolumn = "auto:1"
vim.opt.scrolloff = 4
vim.opt.updatetime = 1000
vim.opt.smoothscroll = true
vim.opt.breakindent = true
vim.opt.linebreak = true
vim.opt.showbreak = "↪ "
vim.opt.virtualedit = "block"
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.splitkeep = "screen"
vim.opt.jumpoptions:append("view")
vim.opt.winborder = "rounded"
vim.opt.diffopt:append("algorithm:histogram")
vim.opt.diffopt:remove("linematch:40")
vim.opt.diffopt:append("linematch:60")
vim.opt.list = true
vim.opt.listchars = {
  tab = "» ",
  trail = "·",
  nbsp = "␣",
  extends = "›",
  precedes = "‹",
}
vim.opt.fillchars:append({
  eob = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
})

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.confirm = true

-- Configure indentation behavior.
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.autoindent = true

vim.opt.number = true
vim.opt.relativenumber = true

-- Configure command-line completion behavior.
vim.opt.inccommand = "split"
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,full"

vim.opt.laststatus = 3
vim.opt.showmode = false

-- ==================================================
-- File types
-- Configure additional file type detection.
-- ==================================================

vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
  },
})

-- Avoid continuing comment leaders automatically in Lua and Rust files.
local formatoptions_group = vim.api.nvim_create_augroup("user-formatoptions", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = formatoptions_group,
  pattern = { "lua", "rust" },
  callback = function()
    vim.opt_local.formatoptions:remove({ "r", "o" })
  end,
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
