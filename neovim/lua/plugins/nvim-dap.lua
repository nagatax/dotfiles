-- Focus a debug view section, opening the view window first when it is closed.
local function jump_to_view(section)
  return function()
    local winnr = require("dap-view.state").winnr
    if not (winnr and vim.api.nvim_win_is_valid(winnr)) then
      require("dap-view").open()
    end
    require("dap-view").jump_to_view(section)
  end
end

return {
  {
    "mfussenegger/nvim-dap",
    dependencies = { "igorlfs/nvim-dap-view" },
    config = function()
      local dap = require("dap")

      -- Run the Xdebug adapter built by the vscode-php-debug spec below.
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = { vim.fn.stdpath("data") .. "/lazy/vscode-php-debug/out/phpDebug.js" },
      }
      dap.configurations.php = {
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
        },
      }
    end,
    -- Configure debugger session, stepping, and breakpoint keymaps.
    keys = {
      { "<F5>", function() require("dap").continue() end, desc = "Debug Continue" },
      { "<F10>", function() require("dap").step_over() end, desc = "Debug Step Over" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Debug Continue" },
      { "<leader>dn", function() require("dap").step_over() end, desc = "Debug Step Over" },
      -- Use leader mappings because the terminal or macOS intercepts <F11> and <F12>.
      { "<leader>di", function() require("dap").step_into() end, desc = "Debug Step Into" },
      { "<leader>do", function() require("dap").step_out() end, desc = "Debug Step Out" },
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug Toggle Breakpoint" },
      {
        "<leader>dB",
        function() require("dap").set_breakpoint(vim.fn.input("Condition: ")) end,
        desc = "Debug Conditional Breakpoint",
      },
      { "<leader>dr", function() require("dap").run_to_cursor() end, desc = "Debug Run to Cursor" },
      { "<leader>dt", function() require("dap").terminate() end, desc = "Debug Terminate" },
      { "<leader>dv", function() require("dap-view").toggle() end, desc = "Debug Toggle View" },
      { "<leader>dW", jump_to_view("watches"), desc = "Debug Jump to Watches" },
      { "<leader>dS", jump_to_view("scopes"), desc = "Debug Jump to Scopes" },
      -- Use L for the breakpoint list because <leader>dB sets a conditional breakpoint.
      { "<leader>dL", jump_to_view("breakpoints"), desc = "Debug Jump to Breakpoints" },
      { "<leader>dE", jump_to_view("exceptions"), desc = "Debug Jump to Exceptions" },
      { "<leader>dT", jump_to_view("threads"), desc = "Debug Jump to Threads" },
      { "<leader>dR", jump_to_view("repl"), desc = "Debug Jump to REPL" },
    },
  },
  {
    "igorlfs/nvim-dap-view",
    lazy = true,
    -- Open the view when a session starts and close it when the session ends.
    opts = { auto_toggle = true },
  },
  {
    -- Provide the Xdebug debug adapter used by nvim-dap.
    "xdebug/vscode-php-debug",
    lazy = true,
    build = "npm install && npm run build",
  },
}
