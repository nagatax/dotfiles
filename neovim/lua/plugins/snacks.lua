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
        chunk = {
          enabled = true,
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
      picker = {},
      notifier = {}, -- Replace vim.notify and expose notification history through <leader>n.
      quickfile = { enabled = true }, -- Render files before the remaining plugins finish loading.
      scope = { enabled = true }, -- Add scope-aware text objects and navigation.
      statuscolumn = { enabled = true }, -- Combine line numbers, signs, folds, and Git status.
      words = { enabled = true }, -- Highlight references reported by attached LSP clients.
    },
    keys = {
      -- Configure file and explorer keymaps.
      { "<leader><space>", function() Snacks.picker.smart() end, desc = "Smart Find Files" },
      { "<leader>e", function() Snacks.explorer() end, desc = "File Explorer" },
      { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },

      -- Configure buffer keymaps.
      { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
      { "<leader>bd", function() Snacks.bufdelete() end, desc = "Delete Buffer" },

      -- Configure search and navigation keymaps.
      { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },
      { "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
      { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Visual selection or word", mode = { "n", "x" } },
      { '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
      { '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
      { "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
      { "<leader>sb", function() Snacks.picker.lines() end, desc = "Buffer Lines" },
      { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Command History" },
      { "<leader>sC", function() Snacks.picker.commands() end, desc = "Commands" },
      { "<leader>fh", function() Snacks.picker.help() end, desc = "Help Pages" },
      { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
      { "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
      { "<leader>fj", function() Snacks.picker.jumps() end, desc = "Jumps" },
      { "<leader>fk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
      { "<leader>fl", function() Snacks.picker.loclist() end, desc = "Location List" },
      { "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
      { "<leader>sM", function() Snacks.picker.man() end, desc = "Man Pages" },
      { "<leader>sp", function() Snacks.picker.lazy() end, desc = "Search for Plugin Spec" },
      { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Quickfix List" },
      { "<leader>sR", function() Snacks.picker.resume() end, desc = "Resume" },
      { "<leader>su", function() Snacks.picker.undo() end, desc = "Undo History" },

      -- Configure Git keymaps.
      { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git Branches" },
      { "<leader>gl", function() Snacks.picker.git_log() end, desc = "Git Log" },
      { "<leader>gL", function() Snacks.picker.git_log_line() end, desc = "Git Log Line" },
      { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },
      { "<leader>gS", function() Snacks.picker.git_stash() end, desc = "Git Stash" },
      { "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (Hunks)" },
      { "<leader>gf", function() Snacks.picker.git_log_file() end, desc = "Git Log File" },
      { "<leader>gB", function() Snacks.gitbrowse() end, desc = "Git Browse", mode = { "n", "v" } },
      { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },

      -- Configure GitHub keymaps.
      { "<leader>gi", function() Snacks.picker.gh_issue() end, desc = "GitHub Issues (open)" },
      { "<leader>gI", function() Snacks.picker.gh_issue({ state = "all" }) end, desc = "GitHub Issues (all)" },
      { "<leader>gp", function() Snacks.picker.gh_pr() end, desc = "GitHub Pull Requests (open)" },
      { "<leader>gP", function() Snacks.picker.gh_pr({ state = "all" }) end, desc = "GitHub Pull Requests (all)" },

      -- Configure LSP keymaps.
      { "<leader>ca", function() vim.lsp.buf.code_action() end, desc = "Code Action" },
      { "<leader>cf", function() vim.lsp.buf.format() end, desc = "Format Buffer" },
      { "<leader>cr", function() vim.lsp.buf.rename() end, desc = "Rename Symbol" },
      { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Goto Definition" },
      { "gD", function() Snacks.picker.lsp_declarations() end, desc = "Goto Declaration" },
      { "gr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "References" },
      { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Goto Implementation" },
      { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto T[y]pe Definition" },
      { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
      { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
      { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "LSP Symbols" },
      { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace Symbols" },

      -- Configure diagnostic keymaps.
      { "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
      { "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
      { "[d", function() jump_diagnostic(-1) end, desc = "Previous Diagnostic" },
      { "]d", function() jump_diagnostic(1) end, desc = "Next Diagnostic" },

      -- Configure quickfix keymaps.
      { "[q", "<cmd>cprev<cr>", desc = "Previous Quickfix" },
      { "]q", "<cmd>cnext<cr>", desc = "Next Quickfix" },

      -- Configure appearance keymaps.
      { "<leader>uC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
      { "<leader>ug", function() Snacks.toggle.indent():toggle() end, desc = "Toggle Indent Guides" },
      { "<leader>uh", function() Snacks.toggle.inlay_hints():toggle() end, desc = "Toggle Inlay Hints" },
      { "<leader>uw", function() Snacks.toggle.option("list", { name = "Whitespace" }):toggle() end, desc = "Toggle Whitespace" },
      { "<leader>uz", function() Snacks.zen() end, desc = "Toggle Zen Mode" },

      -- Configure scratch-buffer keymaps.
      { "<leader>.", function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
      { "<leader>S", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },

      -- Configure notification keymaps.
      { "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },
      { "<leader>un", function() Snacks.notifier.hide() end, desc = "Dismiss All Notifications" },

      -- Configure window navigation and split-management keymaps.
      { "<leader>h", "<C-w>h", desc = "Go to Left Window" },
      { "<leader>j", "<C-w>j", desc = "Go to Lower Window" },
      { "<leader>k", "<C-w>k", desc = "Go to Upper Window" },
      { "<leader>l", "<C-w>l", desc = "Go to Right Window" },
      { "<leader>sh", "<cmd>leftabove vsplit<cr>", desc = "Split Window Left" },
      { "<leader>sj", "<cmd>rightbelow split<cr>", desc = "Split Window Down" },
      { "<leader>sk", "<cmd>leftabove split<cr>", desc = "Split Window Up" },
      { "<leader>sl", "<cmd>rightbelow vsplit<cr>", desc = "Split Window Right" },

      -- Configure quit keymaps.
      { "<leader>qq", "<cmd>qa<cr>", desc = "Quit All" },
      { "<leader>qw", "<cmd>wqa<cr>", desc = "Save and Quit All" },
    },
  },
}
