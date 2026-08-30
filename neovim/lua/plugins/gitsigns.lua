local function selected_lines()
  local first = vim.fn.line(".")
  local last = vim.fn.line("v")

  return { math.min(first, last), math.max(first, last) }
end

return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "[h", function() require("gitsigns").nav_hunk("prev") end, desc = "Previous Git Hunk" },
    { "]h", function() require("gitsigns").nav_hunk("next") end, desc = "Next Git Hunk" },
    { "<leader>ga", function() require("gitsigns").stage_hunk() end, desc = "Stage Git Hunk" },
    {
      "<leader>ga",
      function() require("gitsigns").stage_hunk(selected_lines()) end,
      desc = "Stage Selected Git Hunk",
      mode = "v",
    },
    { "<leader>gR", function() require("gitsigns").reset_hunk() end, desc = "Reset Git Hunk" },
    {
      "<leader>gR",
      function() require("gitsigns").reset_hunk(selected_lines()) end,
      desc = "Reset Selected Git Hunk",
      mode = "v",
    },
    { "<leader>gc", function() require("gitsigns").blame_line() end, desc = "Blame Git Line" },
    { "<leader>gh", function() require("gitsigns").preview_hunk() end, desc = "Preview Git Hunk" },
    { "<leader>gH", function() require("gitsigns").preview_hunk_inline() end, desc = "Preview Git Hunk Inline" },
  },
}
