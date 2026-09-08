return {
  "olimorris/codecompanion.nvim",
  version = "^19.0.0",
  dependencies = {
    { "nvim-lua/plenary.nvim", branch = "master" },
    "nvim-treesitter/nvim-treesitter",
  },
  opts = {
    interactions = {
      chat = { adapter = "codex" },
    },
    adapters = {
      acp = {
        codex = function()
          return require("codecompanion.adapters").extend("codex", {
            defaults = { auth_method = "chat-gpt" },
          })
        end,
      },
    },
  },
}
