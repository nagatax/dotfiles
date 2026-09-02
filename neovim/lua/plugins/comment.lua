return {
  "numToStr/Comment.nvim",
  opts = {},
  config = function(_, opts)
    local comment_ft = require("Comment.ft")
    local calculate = comment_ft.calculate

    -- Neovim 0.12 returns nil instead of raising when no parser is available.
    comment_ft.calculate = function(ctx)
      local ok, parser = pcall(vim.treesitter.get_parser, 0)
      if not ok or not parser then
        return comment_ft.get(vim.bo.filetype, ctx.ctype)
      end

      return calculate(ctx)
    end

    require("Comment").setup(opts)
  end,
}
