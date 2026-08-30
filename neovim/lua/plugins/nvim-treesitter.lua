return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local languages = { "c", "cpp", "go", "lua", "regex", "rust", "terraform", "vim", "vimdoc" }
    local treesitter = require("nvim-treesitter")

    treesitter.setup()
    treesitter.install(languages)

    local function enable_treesitter(bufnr)
      if not vim.list_contains(languages, vim.bo[bufnr].filetype) then
        return
      end

      pcall(vim.treesitter.start, bufnr)
      vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end

    local group = vim.api.nvim_create_augroup("nvim-treesitter", { clear = true })
    vim.api.nvim_create_autocmd("FileType", {
      group = group,
      pattern = languages,
      callback = function(args)
        enable_treesitter(args.buf)
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "TSUpdate",
      callback = function()
        for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
          enable_treesitter(bufnr)
        end
      end,
    })
  end,
}
