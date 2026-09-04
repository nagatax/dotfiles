return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_b = {
        "branch",
        "diff",
        {
          "diagnostics",
          symbols = {
            error = " ",
            warn = " ",
            info = " ",
            hint = " ",
          },
        },
      },
      lualine_c = {
        {
          "filename",
          path = 1,
          -- Highlight unsaved files while retaining the standard status symbols.
          color = function()
            if vim.bo.modified then
              return { fg = "#ef9f76", gui = "bold" }
            end
            return {}
          end,
        },
      },
    },
    extensions = { "lazy", "man", "quickfix" },
  },
}
