return {
  "github/copilot.vim",
  branch = "release",
  lazy = false,

  init = function()
    -- Let blink.cmp handle Tab before falling back to snippet navigation.
    vim.g.copilot_no_tab_map = true
  end,
}
