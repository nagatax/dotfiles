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
        "select_and_accept",
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
      menu = {
        draw = {
          treesitter = { "lsp" },
          -- Keep long completion items compact in split windows.
          components = {
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
