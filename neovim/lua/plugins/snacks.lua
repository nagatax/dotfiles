local function jump_diagnostic(count)
  vim.diagnostic.jump({
    count = count,
    on_jump = function(_, bufnr)
      vim.diagnostic.open_float({
        bufnr = bufnr,
        scope = "cursor",
        focus = false,
      })
    end,
  })
end

local function copy_file_reference(line_range)
  local path = vim.fn.expand("%:.")
  if path == "" then
    vim.notify("Current buffer has no file path", vim.log.levels.WARN)
    return
  end

  local reference = path
  if line_range == "cursor" then
    reference = ("%s:%d"):format(path, vim.fn.line("."))
  elseif line_range == "visual" then
    local first_line = vim.fn.line("v")
    local last_line = vim.fn.line(".")
    if first_line > last_line then
      first_line, last_line = last_line, first_line
    end
    reference = ("%s:%d-%d"):format(path, first_line, last_line)
  end

  vim.fn.setreg("+", reference)
  vim.notify(("Copied %s"):format(reference))
end

return {
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000,
    ---@type snacks.Config
    opts = {
      bigfile = { enabled = true }, -- Disable expensive features for large files.
      dashboard = {
        enabled = true,
        width = 52,
        preset = {
          header = [[
╭──────────────────╮
│    N E O V I M  │
╰──────────────────╯]],
        },
        formats = {
          key = function(item)
            return {
              { "", hl = "SnacksDashboardKeyCap" },
              { item.key, hl = "SnacksDashboardKey" },
              { "", hl = "SnacksDashboardKeyCap" },
            }
          end,
        },
        sections = {
          { section = "header" },
          { icon = " ", title = "Keymaps", section = "keys", indent = 2, padding = 1 },
          { icon = " ", title = "Recent Files", section = "recent_files", limit = 5, indent = 2, padding = 1 },
          { icon = " ", title = "Projects", section = "projects", limit = 5, indent = 2, padding = 1 },
          {
            icon = " ",
            title = "Git Status",
            section = "terminal",
            enabled = function()
              return Snacks.git.get_root() ~= nil
            end,
            cmd = "git status --short --branch --renames",
            height = 5,
            padding = 1,
            ttl = 5 * 60,
            indent = 3,
          },
          { section = "startup", icon = "󰥔 " },
        },
      },
      explorer = {
        replace_netrw = true, -- Replace netrw with the Snacks explorer.
        trash = true, -- Move deleted files to the system trash.
      },
      indent = {
        enabled = true, -- Visualize indentation and the current scope.
        scope = { only_current = true },
        chunk = {
          enabled = true,
          only_current = true,
          char = {
            corner_top = "╭",
            corner_bottom = "╰",
            horizontal = "─",
            vertical = "│",
            arrow = ">",
          },
        },
      },
      input = { enabled = true }, -- Replace vim.ui.input with a floating input window.
      picker = {
        formatters = {
          file = { filename_first = true, min_width = 20 },
        },
      },
      notifier = { gap = 1, style = "fancy" }, -- Separate notifications and expose history through <leader>n.
      quickfile = { enabled = true }, -- Render files before the remaining plugins finish loading.
      scope = { enabled = true }, -- Add scope-aware text objects and navigation.
      statuscolumn = {
        enabled = true, -- Combine line numbers, signs, folds, and Git status.
        folds = { git_hl = true },
      },
      words = { enabled = true }, -- Highlight references reported by attached LSP clients.
    },
    keys = {
      -- Configure file and buffer keymaps.
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      {
        "<leader>e",
        function()
          local explorer = Snacks.picker.get({ source = "explorer" })[1]
          if explorer then
            explorer:focus()
          else
            Snacks.explorer()
          end
        end,
        desc = "Focus File Explorer",
      },
      { "<leader>,", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>b", function() Snacks.bufdelete() end, desc = "Delete Buffer" },
      { "<leader>y", function() copy_file_reference() end, desc = "Copy File Path" },
      { "<leader>Y", function() copy_file_reference("cursor") end, desc = "Copy File Reference" },
      { "<leader>Y", function() copy_file_reference("visual") end, desc = "Copy File Range", mode = "x" },

      -- Configure search, history, and help keymaps.
      { "<leader>/", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>w", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      { "<leader>c", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>s", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>u", function() Snacks.picker.undo() end, desc = "Undo History" },

      -- Configure Git keymaps.
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>v", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>p", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      { "<leader>t", function() Snacks.lazygit() end, desc = "Lazygit" },

      -- Configure code-action and symbol-list keymaps.
      { "<leader>a", function() vim.lsp.buf.code_action() end, desc = "Code Action" },
      { "<leader>=", function() vim.lsp.buf.format() end, desc = "Format Buffer" },
      { "<leader>r", function() vim.lsp.buf.rename() end, desc = "Rename Symbol" },
      { "<leader>o", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>O", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

      -- Configure definition and reference navigation keymaps.
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },

      -- Configure diagnostic keymaps.
      { "<leader>X", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>x", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "[d", function() jump_diagnostic(-1) end, desc = "Previous Diagnostic" },
      { "]d", function() jump_diagnostic(1) end, desc = "Next Diagnostic" },

      -- Configure quickfix keymaps.
      { "[q", "<cmd>cprev<cr>", desc = "Previous Quickfix" },
      { "]q", "<cmd>cnext<cr>", desc = "Next Quickfix" },

      -- Configure notification keymaps.
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },

      -- Configure window navigation keymaps.
      { "<leader>h", "<C-w>h", desc = "Go to Left Window" },
      { "<leader>j", "<C-w>j", desc = "Go to Lower Window" },
      { "<leader>k", "<C-w>k", desc = "Go to Upper Window" },
      { "<leader>l", "<C-w>l", desc = "Go to Right Window" },

      -- Configure quit keymaps.
      { "<leader>q", "<cmd>qa<cr>", desc = "Quit All" },
      { "<leader>Q", "<cmd>wqa<cr>", desc = "Save and Quit All" },
    },
  },
}
