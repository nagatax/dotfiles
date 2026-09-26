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

vim.opt.hlsearch = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "screenline,number"
vim.opt.signcolumn = "yes"
-- Use a fixed width because "auto" rescans every fold in the buffer on each cursor move.
vim.opt.foldcolumn = "1"
vim.opt.foldtext = ""
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
vim.opt.switchbuf = "useopen,usetab,uselast"
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
  -- Draw indent guides natively instead of recomputing them in Lua on every redraw.
  leadmultispace = "│   ",
  extends = "›",
  precedes = "‹",
}
vim.opt.fillchars:append({
  eob = " ",
  diff = "╱",
  fold = " ",
  foldopen = "",
  foldclose = "",
  foldsep = " ",
  -- Hide nesting-depth digits in the one-column fold gutter.
  foldinner = " ",
})

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.confirm = true

-- Configure indentation behavior.
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
-- Round manual indentation shifts to multiples of the buffer's indent width.
vim.opt.shiftround = true
vim.opt.autoindent = true

vim.opt.number = true
vim.opt.relativenumber = true

-- Show absolute numbers while inserting and relative numbers for counted motions elsewhere.
local relativenumber_group = vim.api.nvim_create_augroup("user.relativenumber", { clear = true })
vim.api.nvim_create_autocmd("InsertEnter", {
  group = relativenumber_group,
  callback = function()
    if vim.wo.number then vim.wo.relativenumber = false end
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = relativenumber_group,
  callback = function()
    if vim.wo.number then vim.wo.relativenumber = true end
  end,
})

-- Bound bracket-matching searches so cursor movement stays responsive on long lines.
vim.g.matchparen_timeout = 20
vim.g.matchparen_insert_timeout = 20

-- Configure command-line completion behavior.
vim.opt.inccommand = "split"
vim.opt.wildmenu = true
vim.opt.wildmode = "list:longest,full"

vim.opt.laststatus = 3

-- Briefly highlight copied text to make the yank range visible.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("user.yank-highlight", { clear = true }),
  callback = function()
    vim.hl.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
})

-- ==================================================
-- Clipboard
-- Sync with the macOS clipboard asynchronously instead of blocking every
-- yank, delete, and paste on pbcopy/pbpaste.
-- ==================================================

local clipboard_group = vim.api.nvim_create_augroup("user.clipboard", { clear = true })
-- Track the last text exchanged with the system clipboard so unchanged
-- clipboard contents never overwrite text deleted inside Neovim.
local last_clipboard = nil

-- Send plain yanks to the system clipboard; deletes and changes stay local.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = clipboard_group,
  callback = function()
    local event = vim.v.event
    if event.operator ~= "y" or event.regname ~= "" then
      return
    end

    local text = table.concat(event.regcontents, "\n")
    if event.regtype == "V" then
      text = text .. "\n"
    end
    last_clipboard = text
    vim.system({ "pbcopy" }, { stdin = text })
  end,
})

-- Load text copied in other applications into the unnamed register.
local function import_clipboard()
  vim.system({ "pbpaste" }, { text = true }, function(out)
    if out.code ~= 0 or out.stdout == "" then
      return
    end
    vim.schedule(function()
      if out.stdout == last_clipboard then
        return
      end
      last_clipboard = out.stdout
      vim.fn.setreg('"', out.stdout)
    end)
  end)
end

vim.api.nvim_create_autocmd("FocusGained", {
  group = clipboard_group,
  callback = import_clipboard,
})
vim.schedule(import_clipboard)

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
local formatoptions_group = vim.api.nvim_create_augroup("user.formatoptions", { clear = true })
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
-- Plugin manager
-- Load the lazy.nvim plugin configuration.
-- ==================================================

require("config.lazy")
require("config.statusline").setup()

-- ==================================================
-- Built-in plugins
-- Load optional plugins distributed with Neovim.
-- ==================================================

vim.cmd.packadd("nvim.difftool")
