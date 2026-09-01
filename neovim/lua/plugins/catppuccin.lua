return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,

  opts = {
    flavour = "frappe",
    term_colors = true,
    float = {
      solid = true,
    },
    dim_inactive = {
      enabled = true,
      shade = "dark",
      percentage = 0.10,
    },
  },

  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
