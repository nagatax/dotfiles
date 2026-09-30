-- Inline completion ranges are computed when requested, so text deleted before accepting can leave them past the line end.
-- Clamp the range to the current buffer, and drop the item when its start no longer exists.
local function clamp_inline_completion(item)
  local range = item.range
  if not range then
    return item
  end

  local buf = range.buf
  local start_row, start_col, end_row, end_col = range:to_extmark()
  local last_row = vim.api.nvim_buf_line_count(buf) - 1
  local start_line = vim.api.nvim_buf_get_lines(buf, start_row, start_row + 1, false)[1]
  if not start_line or start_col > #start_line then
    return nil
  end

  end_row = math.min(end_row, last_row)
  local end_line = vim.api.nvim_buf_get_lines(buf, end_row, end_row + 1, false)[1]
  end_col = math.min(end_col, #end_line)
  item.range = vim.range.extmark(buf, start_row, start_col, end_row, end_col)
  return item
end

return {
  "saghen/blink.cmp",

  -- Use a release tag to download pre-built binaries.
  version = "1.*",
  -- Load on first completion use; config.lsp loads it earlier when a file is opened.
  event = "InsertEnter",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- Configure completion keymaps; inherit the remaining preset bindings.
    keymap = {
      preset = "default",

      ["<Tab>"] = {
        function() return vim.lsp.inline_completion.get({ on_accept = clamp_inline_completion }) end,
        "snippet_forward",
        "fallback",
      },

      ["<CR>"] = {
        "accept",
        "fallback",
      },
    },

    -- Declare default providers here so opts_extend can extend them elsewhere.
    -- Skip the buffer source, which rescans buffer words on every keystroke.
    sources = {
      default = { "lsp", "path", "snippets" },
      providers = {
        -- Include dotfiles before a dot is explicitly typed in a path.
        path = { opts = { show_hidden_files_by_default = true } },
      },
    },

    completion = {
      -- Keep Enter as a newline until a completion item is explicitly selected.
      list = {
        -- Keep the buffer unchanged while browsing completion candidates.
        selection = { preselect = false, auto_insert = false },
      },
      menu = {
        draw = {
          padding = { 0, 1 },
          -- Keep long completion items compact in split windows.
          components = {
            kind_icon = {
              -- Pad the colored kind badge while preserving the existing columns.
              text = function(ctx) return " " .. ctx.kind_icon .. ctx.icon_gap .. " " end,
            },
            label = { width = { max = 40 } },
            label_description = { width = { max = 20 } },
            source_name = { width = { max = 10 } },
          },
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "source_name" },
          },
        },
      },
      -- Show documentation only on demand with <C-space> to avoid a request on every selection change.
      documentation = {
        auto_show = false,
      },
    },

    -- Keep the command line on built-in completion to avoid work on every ":" keystroke.
    cmdline = { enabled = false },

    signature = {
      enabled = true,
      -- Show signatures only on demand with <C-k> to avoid a request on every trigger character.
      trigger = { enabled = false },
      -- Include documentation supplied by the language server.
      window = { show_documentation = true },
    },
  },
}
