return {
  "saghen/blink.cmp",

  -- Use a release tag to download pre-built binaries.
  version = "1.*",
  -- Load on first completion use; lspconfig loads it earlier when a file is opened.
  event = { "InsertEnter", "CmdlineEnter" },

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- Configure completion keymaps; inherit the remaining preset bindings.
    keymap = {
      preset = "default",

      ["<Tab>"] = {
        function() return vim.lsp.inline_completion.get() end,
        "snippet_forward",
        "fallback",
      },

      ["<CR>"] = {
        "accept",
        "fallback",
      },
    },

    -- Declare default providers here so opts_extend can extend them elsewhere.
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
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
          treesitter = { "lsp" },
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

    signature = {
      enabled = true,
      -- Show signatures only on demand with <C-k> to avoid a request on every trigger character.
      trigger = { enabled = false },
      -- Include documentation supplied by the language server.
      window = { show_documentation = true },
    },
  },
}
