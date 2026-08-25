return {
  "neovim/nvim-lspconfig",
  dependencies = { "saghen/blink.cmp" },
  config = function()
    vim.lsp.config("rust_analyzer", {
      settings = {
        ["rust-analyzer"] = {
          check = {
            command = "clippy",
          },
        },
      }
    })
    vim.lsp.config("terraformls", { filetypes = { "tf", "terraform", "terraform-vars" } })

    vim.lsp.enable("clangd")
    vim.lsp.enable("rust_analyzer")
    vim.lsp.enable("gopls")
    vim.lsp.enable("terraformls")
    vim.lsp.enable("intelephense")
    vim.lsp.enable("basedpyright")

    -- 診断表示
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      severity_sort = true,
      update_in_insert = false,
      float = {
        border = "rounded",
        source = true,
      },
    })

    -- Rustファイル保存時にrustfmt
    vim.api.nvim_create_autocmd("BufWritePre", {
      pattern = "*.rs",
      callback = function(args)
        vim.lsp.buf.format({
          bufnr = args.buf,
          async = false,
          timeout_ms = 3000,
        })
      end,
    })
  end,
}
