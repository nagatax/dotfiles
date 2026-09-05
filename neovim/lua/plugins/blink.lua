return {
  "saghen/blink.cmp",

  -- Use a release tag to download pre-built binaries.
  version = "1.*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- Configure completion keymaps; inherit the remaining preset bindings.
    keymap = {
      preset = "default",

      ["<CR>"] = {
        "accept",
        "fallback",
      },
    },

    -- Declare default providers here so opts_extend can extend them elsewhere.
    sources = {
      default = { "lsp", "path", "snippets", "buffer" },
      per_filetype = {
        lua = { inherit_defaults = true, "lazydev" },
      },
      providers = {
        lazydev = {
          name = "LazyDev",
          module = "lazydev.integrations.blink",
          score_offset = 100,
        },
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
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 500,
      },
    },

    signature = {
      enabled = true,
    },
  },
}
