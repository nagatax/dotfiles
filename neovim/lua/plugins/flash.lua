return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      char = {
        jump_labels = true,
      },
      search = {
        enabled = true,
      },
    },
  },
  keys = {
    {
      "<leader>Fj",
      mode = { "n", "x", "o" },
      function() require("flash").jump() end,
      desc = "Flash Jump",
    },
    {
      "<leader>Ft",
      mode = { "n", "x", "o" },
      function() require("flash").treesitter() end,
      desc = "Flash Treesitter Selection",
    },
  },
}
