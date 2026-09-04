return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      globalstatus = true,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_c = { { "filename", path = 1 } },
    },
    extensions = { "lazy", "man", "quickfix" },
  },
}
