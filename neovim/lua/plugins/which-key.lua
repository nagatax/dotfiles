return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>m",
      function()
        require("which-key").show({ keys = "<leader>D", loop = true })
      end,
      desc = "Repeat Debug Actions",
    },
  },
  opts = {
    spec = {
      { "<leader>D", group = "Debug" },
      { "<leader>g", group = "Git" },
    },
  },
}
