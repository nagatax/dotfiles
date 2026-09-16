return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    show_help = false,
    spec = {
      { "<leader>D", group = "Debug" },
      { "<leader>g", group = "Git" },
    },
  },
}
