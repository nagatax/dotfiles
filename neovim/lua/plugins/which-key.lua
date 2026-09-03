return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    spec = {
      { "<leader>b", group = "Buffer" },
      { "<leader>c", group = "Code" },
      { "<leader>d", group = "Diff" },
      { "<leader>D", group = "Debug" },
      { "<leader>f", group = "Find" },
      { "<leader>F", group = "Flash" },
      { "<leader>g", group = "Git" },
      { "<leader>q", group = "Quit" },
      { "<leader>r", group = "Resize" },
      { "<leader>s", group = "Search" },
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
