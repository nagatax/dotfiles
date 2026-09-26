-- Render the statusline and winbar with built-in options instead of a plugin.
-- Keep rendering cheap because Neovim evaluates the statusline on every cursor move.
local M = {}

-- Cache the Git branch per directory so rendering never spawns a process.
local branches = {} ---@type table<string, string>
local pending = {} ---@type table<string, boolean>
-- Keep showing stale branches until the refresh finishes to avoid flicker.
local stale = {} ---@type table<string, boolean>

local diagnostic_signs = {
  { vim.diagnostic.severity.ERROR, "DiagnosticError", "\u{f057} " },
  { vim.diagnostic.severity.WARN, "DiagnosticWarn", "\u{f071} " },
  { vim.diagnostic.severity.INFO, "DiagnosticInfo", "\u{f05a} " },
  { vim.diagnostic.severity.HINT, "DiagnosticHint", "\u{f0eb} " },
}

local function escape(text)
  return (text:gsub("%%", "%%%%"))
end

local function buf_dir(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" or vim.bo[bufnr].buftype ~= "" then
    return vim.fn.getcwd()
  end
  return vim.fs.dirname(name)
end

local function refresh_branch(bufnr)
  local dir = buf_dir(bufnr)
  if pending[dir] or not vim.uv.fs_stat(dir) then
    return
  end

  pending[dir] = true
  vim.system({ "git", "branch", "--show-current" }, { cwd = dir, text = true }, function(out)
    vim.schedule(function()
      pending[dir] = nil
      stale[dir] = nil
      local branch = out.code == 0 and vim.trim(out.stdout) or ""
      if branches[dir] ~= branch then
        branches[dir] = branch
        vim.cmd.redrawstatus()
      end
    end)
  end)
end

local function diagnostics()
  local counts = vim.diagnostic.count(0)
  local items = {}
  for _, sign in ipairs(diagnostic_signs) do
    local count = counts[sign[1]]
    if count then
      table.insert(items, ("%%#%s#%s%d"):format(sign[2], sign[3], count))
    end
  end
  return table.concat(items, " ")
end

-- Show sidekick state only after sidekick has loaded; never load it just to render.
local function sidekick()
  if not package.loaded["sidekick"] then
    return ""
  end

  local status = require("sidekick.status")
  local items = {}
  local sessions = status.cli()
  if #sessions > 0 then
    table.insert(items, "%#Special#\u{ee0d} " .. (#sessions > 1 and #sessions or ""))
  end

  local copilot = status.get()
  if copilot then
    local hl = copilot.kind == "Error" and "DiagnosticError" or copilot.busy and "DiagnosticWarn" or "Special"
    table.insert(items, ("%%#%s#\u{f4b8} "):format(hl))
  end
  return table.concat(items, " ")
end

-- Show encoding and file format only when they differ from UTF-8 and unix.
local function file_format()
  local items = {}
  local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
  if encoding ~= "utf-8" or vim.bo.bomb then
    table.insert(items, encoding .. (vim.bo.bomb and " [BOM]" or ""))
  end
  if vim.bo.fileformat ~= "unix" then
    table.insert(items, vim.bo.fileformat)
  end
  return table.concat(items, " ")
end

function M.render()
  local left = {}
  local branch = branches[buf_dir(0)]
  if branch and branch ~= "" then
    table.insert(left, "%#UserStatusBranch#\u{e725} " .. escape(branch) .. "%#StatusLine#")
  end
  local diagnostic = diagnostics()
  if diagnostic ~= "" then
    table.insert(left, diagnostic .. "%#StatusLine#")
  end
  -- Highlight unsaved files while retaining the standard status symbols.
  local filename_hl = vim.bo.modified and "%#UserStatusModified#" or ""
  table.insert(left, filename_hl .. "%t%#StatusLine#%( %m%r%h%w%)")

  local right = {}
  for _, item in ipairs({ sidekick(), file_format(), vim.bo.filetype }) do
    if item ~= "" then
      table.insert(right, item .. "%#StatusLine#")
    end
  end
  table.insert(right, "%3P")
  table.insert(right, "%#UserStatusPosition# %3l:%-2v %#StatusLine#")

  return " " .. table.concat(left, "  ") .. "%<%=" .. table.concat(right, "  ")
end

-- Show the relative path of the file in each window.
function M.winbar()
  local bufnr = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == "" then
    return " [No Name]"
  end
  return " " .. escape(vim.fn.fnamemodify(name, ":.")) .. (vim.bo[bufnr].modified and " [+]" or "")
end

local winbar = "%!v:lua.require'config.statusline'.winbar()"

-- Attach the winbar only to ordinary file windows so pickers, terminals, and floats keep their full height.
local function update_winbar(winid)
  if not vim.api.nvim_win_is_valid(winid) then
    return
  end
  local bufnr = vim.api.nvim_win_get_buf(winid)
  local is_file = vim.bo[bufnr].buftype == "" and vim.api.nvim_win_get_config(winid).relative == ""
  local value = is_file and winbar or ""
  if vim.wo[winid].winbar ~= value then
    vim.wo[winid].winbar = value
  end
end

function M.setup()
  vim.o.statusline = "%!v:lua.require'config.statusline'.render()"

  local group = vim.api.nvim_create_augroup("user.statusline", { clear = true })
  vim.api.nvim_create_autocmd({ "BufWinEnter", "WinEnter", "TermOpen" }, {
    group = group,
    callback = function()
      update_winbar(vim.api.nvim_get_current_win())
    end,
  })
  vim.api.nvim_create_autocmd("OptionSet", {
    group = group,
    pattern = "buftype",
    callback = function()
      update_winbar(vim.api.nvim_get_current_win())
    end,
  })

  vim.api.nvim_create_autocmd("BufEnter", {
    group = group,
    callback = function(args)
      local dir = buf_dir(args.buf)
      if branches[dir] == nil or stale[dir] then
        refresh_branch(args.buf)
      end
    end,
  })
  -- Branches can change outside Neovim or from lazygit running in a terminal window.
  vim.api.nvim_create_autocmd({ "FocusGained", "DirChanged", "TermClose" }, {
    group = group,
    callback = function()
      for dir in pairs(branches) do
        stale[dir] = true
      end
      vim.schedule(function()
        refresh_branch(vim.api.nvim_get_current_buf())
      end)
    end,
  })
  -- Rendering reads diagnostics directly, so redraw when they change.
  vim.api.nvim_create_autocmd("DiagnosticChanged", {
    group = group,
    callback = function()
      vim.cmd.redrawstatus()
    end,
  })
end

return M
