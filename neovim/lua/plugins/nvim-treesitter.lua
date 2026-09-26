local languages = {
  "c",
  "cpp",
  "gitattributes",
  "gitcommit",
  "gitignore",
  "go",
  "gotmpl",
  "json",
  "lua",
  "markdown",
  "php",
  "python",
  "regex",
  "rust",
  "terraform",
  "toml",
  "vim",
  "vimdoc",
  "zsh",
}

-- Highlighting and folding use built-in APIs with the installed parsers, so this runs without loading the plugin.
local function enable_treesitter(bufnr)
  if not vim.list_contains(languages, vim.bo[bufnr].filetype) then
    return
  end
  if not pcall(vim.treesitter.start, bufnr) then
    return
  end

  -- Tree-sitter indentation and folding re-parse the buffer, so large files keep the built-in behavior.
  if vim.api.nvim_buf_line_count(bufnr) > 5000 then
    return
  end
  -- Requiring nvim-treesitter from indentexpr loads the plugin on the first indent.
  vim.bo[bufnr].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
  for _, winid in ipairs(vim.fn.win_findbuf(bufnr)) do
    vim.wo[winid].foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.wo[winid].foldmethod = "expr"
    vim.wo[winid].foldlevel = 99
  end
end

return {
  "nvim-treesitter/nvim-treesitter",
  -- Load only for parser management or tree-sitter indentation instead of at startup.
  cmd = { "TSInstall", "TSUpdate", "TSUninstall", "TSLog" },
  build = ":TSUpdate",
  init = function()
    local group = vim.api.nvim_create_augroup("user.treesitter", { clear = true })
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
  config = function()
    local treesitter = require("nvim-treesitter")

    treesitter.setup()
    treesitter.install(languages)
  end,
}
