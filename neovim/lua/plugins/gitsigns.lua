return {
  "lewis6991/gitsigns.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    { "[h", function() require("gitsigns").nav_hunk("prev") end, desc = "Previous Git Hunk" },
    { "]h", function() require("gitsigns").nav_hunk("next") end, desc = "Next Git Hunk" },
    { "<leader>gh", function() require("gitsigns").preview_hunk() end, desc = "Preview Git Hunk" },
    { "<leader>gH", function() require("gitsigns").preview_hunk_inline() end, desc = "Preview Git Hunk Inline" },
  },
}
