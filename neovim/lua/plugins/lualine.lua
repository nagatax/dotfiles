-- Show file names above ordinary editing buffers, including inactive splits.
local function file_winbar(color)
  return {
    lualine_c = {
      {
        "filename",
        path = 1,
        color = { fg = color },
        cond = function()
          return vim.bo.buftype == ""
        end,
      },
    },
  }
end

return {
  "nvim-lualine/lualine.nvim",
  opts = {
    options = {
      globalstatus = true,
      -- Keep the tabline hidden until multiple tab pages are open.
      always_show_tabline = false,
      component_separators = { left = "", right = "" },
      section_separators = { left = "", right = "" },
    },
    sections = {
      lualine_x = {
        -- Show the active chat's resolved model and reasoning effort.
        function()
          local metadata = (_G.codecompanion_chat_metadata or {})[vim.api.nvim_get_current_buf()]
          if not metadata then
            return ""
          end
          local model_option = metadata.config_options and metadata.config_options.model
          local model = (model_option and model_option.current)
            or (metadata.adapter and metadata.adapter.model)
          if type(model) ~= "string" or model == "" or model == "default" then
            return ""
          end
          local effort_option = metadata.config_options and metadata.config_options.thought_level
          local effort = effort_option and effort_option.current
          if type(effort) == "string" and effort ~= "" then
            return model .. " [" .. effort .. "]"
          end
          return model
        end,
        -- Show the current search position while bounding search-count work.
        { "searchcount", maxcount = 999, timeout = 100 },
        -- Show encoding only when it differs from UTF-8 or includes a BOM.
        function()
          local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
          if encoding == "utf-8" and not vim.bo.bomb then
            return ""
          end
          return encoding .. (vim.bo.bomb and " [BOM]" or "")
        end,
        {
          "fileformat",
          cond = function()
            return vim.bo.fileformat ~= "unix"
          end,
        },
        "filetype",
      },
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
          -- Keep the relative path in the winbar and the filename in the statusline.
          path = 0,
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
    tabline = {
      lualine_a = {
        {
          "tabs",
          -- Identify each tab by number and its current file without duplicating paths.
          mode = 2,
          path = 0,
          tab_max_length = 30,
          max_length = function() return vim.o.columns end,
        },
      },
    },
    winbar = file_winbar("#c6d0f5"),
    inactive_winbar = file_winbar("#838ba7"),
    extensions = { "lazy", "man", "quickfix" },
  },
}
