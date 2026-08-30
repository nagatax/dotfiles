return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "Diff" },
      { "<leader>f", group = "Find" },
      { "<leader>g", group = "Git" },
      { "<leader>q", group = "Quit" },
      { "<leader>r", group = "Resize" },
      { "<leader>t", group = "Terminal" },
      { "<leader>u", group = "UI" },
    },
  },
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps",
    },
  },
}
