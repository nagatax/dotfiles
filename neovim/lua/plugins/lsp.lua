return {
  {
    "saghen/blink.cmp",

    -- use a release tag to download pre-built binaries
    version = "1.*",

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        preset = "default",

        ["<CR>"] = {
          "select_and_accept",
          "fallback",
        },
      },

      -- Default list of enabled providers defined so that you can extend it
      -- elsewhere in your config, without redefining it, due to `opts_extend`
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      signature = {
        enabled = true,
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      local capabilities = require("blink.cmp").get_lsp_capabilities()

      vim.lsp.config("clangd", { capabilities = capabilities })
      vim.lsp.config("rust_analyzer", { capabilities = capabilities })
      vim.lsp.config("gopls", { capabilities = capabilities })
      vim.lsp.config("terraformls", { capabilities = capabilities, filetypes = { "tf", "terraform", "terraform-vars" } })

      vim.lsp.enable("clangd")
      vim.lsp.enable("rust_analyzer")
      vim.lsp.enable("gopls")
      vim.lsp.enable("terraformls")
    end,
  },
}
