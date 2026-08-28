return {
  "saghen/blink.cmp",

  -- Use a release tag to download pre-built binaries.
  version = "1.*",

  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
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
    },

    signature = {
      enabled = true,
    },
  },
}
