return {
  "catppuccin/nvim",
  name = "catppuccin",
  lazy = false,
  priority = 1000,

  opts = {
    flavour = "frappe",
    term_colors = true,
    -- List integrations explicitly to skip plugin detection on every startup.
    auto_integrations = false,
    integrations = {
      snacks = true,
    },
    float = {
      solid = true,
    },
    lsp_styles = {
      underlines = {
        errors = { "undercurl" },
        warnings = { "undercurl" },
      },
      inlay_hints = {
        background = false,
      },
    },
    highlight_overrides = {
      frappe = function(colors)
        return {
          -- Match Ghostty and tmux search colors; IncSearch also marks yanked text.
          Search = { fg = colors.text, bg = colors.surface2 },
          CurSearch = { fg = colors.base, bg = colors.yellow, bold = true },
          IncSearch = { fg = colors.base, bg = colors.yellow, bold = true },
          -- Make paired brackets stand out without changing their accent color.
          MatchParen = { fg = colors.peach, bg = colors.surface2, bold = true, underline = true },
          -- Keep diagnostic text colors and italics without a background block.
          DiagnosticVirtualTextError = { fg = colors.red, bg = "NONE", italic = true },
          DiagnosticVirtualTextWarn = { fg = colors.yellow, bg = "NONE", italic = true },
          DiagnosticVirtualTextInfo = { fg = colors.sky, bg = "NONE", italic = true },
          DiagnosticVirtualTextHint = { fg = colors.teal, bg = "NONE", italic = true },
          -- Color statusline and winbar parts rendered by config.statusline.
          UserStatusBranch = { fg = colors.mauve, bold = true },
          UserStatusModified = { fg = colors.peach, bold = true },
          UserStatusPosition = { fg = colors.base, bg = colors.blue, bold = true },
          WinBar = { fg = colors.text },
          WinBarNC = { fg = colors.overlay1 },
          LineNr = { fg = colors.overlay0 },
          Whitespace = { fg = colors.overlay0 },
          WinSeparator = { fg = colors.surface2 },
          FloatBorder = { fg = colors.surface2, bg = colors.mantle },
          SnacksPickerMatch = { fg = colors.blue, bold = true, underline = true },
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
