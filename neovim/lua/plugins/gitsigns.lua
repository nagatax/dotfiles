return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  opts = {
    word_diff = true,
    -- Show the current line's last change after the default one-second delay.
    current_line_blame = true,
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
