return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {},
  keys = {
    {
      "<leader>F",
      mode = { "n", "x", "o" },
      function() require("flash").jump() end,
      desc = "Flash Jump",
    },
    {
      "<C-Space>",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter({
          actions = {
            ["<C-Space>"] = "next",
            ["<BS>"] = "prev",
          },
        })
      end,
      desc = "Flash Treesitter Selection",
    },
  },
}
