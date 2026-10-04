return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    show_help = false,
    -- Only hook <leader> so g, z, d, y and other prefixes stay native.
    triggers = {
      { "<leader>", mode = { "n", "x" } },
    },
    -- These plugins add their own triggers on ', `, " and z=.
    plugins = {
      marks = false,
      registers = false,
      spelling = { enabled = false },
    },
    spec = {
      { "<leader>d", group = "Debug" },
      { "<leader>g", group = "Git" },
      { "<leader>i", group = "AI" },
    },
  },
}
