return {
  "folke/sidekick.nvim",
  version = "^2.0.0",
  opts = {
    -- Keep Copilot suggestions to built-in inline completion; NES requests after every normal-mode edit.
    nes = { enabled = false },
    cli = {
      mux = {
        backend = "tmux",
        enabled = true,
      },
    },
  },
  keys = {
    {
      "<leader>ii",
      function() require("sidekick.cli").toggle({ name = "codex", focus = true }) end,
      desc = "Toggle Codex",
    },
    {
      "<leader>is",
      function() require("sidekick.cli").select({ filter = { installed = true } }) end,
      desc = "Select AI CLI",
    },
    {
      "<leader>id",
      function() require("sidekick.cli").close() end,
      desc = "Detach AI CLI",
    },
    {
      "<leader>it",
      function() require("sidekick.cli").send({ msg = "{this}" }) end,
      mode = { "n", "x" },
      desc = "Send This",
    },
    {
      "<leader>if",
      function() require("sidekick.cli").send({ msg = "{file}" }) end,
      desc = "Send File",
    },
    {
      "<leader>iv",
      function() require("sidekick.cli").send({ msg = "{selection}" }) end,
      mode = "x",
      desc = "Send Selection",
    },
    {
      "<leader>ip",
      function() require("sidekick.cli").prompt() end,
      mode = { "n", "x" },
      desc = "Select AI Prompt",
    },
  },
}
