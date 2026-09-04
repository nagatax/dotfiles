return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  opts = {
    word_diff = true,
    -- Distinguish additions and changes by shape as well as color.
    signs = {
      add = { text = "+" },
      change = { text = "~" },
    },
    signs_staged = {
      add = { text = "+" },
      change = { text = "~" },
    },
  },
}
