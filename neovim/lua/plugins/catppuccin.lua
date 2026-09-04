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
    lsp_styles = {
      inlay_hints = {
        background = false,
      },
    },
    highlight_overrides = {
      frappe = function(colors)
        return {
          FloatBorder = { fg = colors.surface2, bg = colors.mantle },
          SnacksDashboardHeader = { fg = colors.mauve },
          SnacksDashboardTitle = { fg = colors.lavender, bold = true },
          SnacksDashboardDesc = { fg = colors.subtext1 },
          SnacksDashboardFooter = { fg = colors.overlay0, italic = true },
          SnacksDashboardKey = { fg = colors.base, bg = colors.peach, bold = true },
          SnacksDashboardKeyCap = { fg = colors.peach },
        }
      end,
    },
  },

  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
