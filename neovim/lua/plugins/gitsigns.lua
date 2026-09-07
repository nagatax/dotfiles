return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  opts = {
    word_diff = true,
    -- Show the current line's last change after the default one-second delay.
    current_line_blame = true,
    -- Trace past whitespace-only changes in the current line annotation.
    current_line_blame_opts = { ignore_whitespace = true },
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
