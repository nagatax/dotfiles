return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      treesitter = {
        label = { rainbow = { enabled = true } },
      },
      char = {
        jump_labels = true,
      },
      search = {
        enabled = true,
      },
    },
  },
  -- Configure Flash navigation and syntax-selection keymaps.
  keys = {
    {
      "<leader>f",
      mode = { "n", "x", "o" },
      function() require("flash").jump() end,
      desc = "Flash Jump",
    },
    {
      "<leader>F",
      mode = { "n", "x", "o" },
      function() require("flash").treesitter() end,
      desc = "Flash Treesitter Selection",
    },
  },
}
