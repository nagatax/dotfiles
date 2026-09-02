return {
  "mfussenegger/nvim-dap",
  ft = "python",
  dependencies = {
    "mfussenegger/nvim-dap-python",
    "nvim-neotest/nvim-nio",
    "rcarriga/nvim-dap-ui",
    "theHamsta/nvim-dap-virtual-text",
  },
  keys = {
    { "<leader>Db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
    {
      "<leader>DB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Set Conditional Breakpoint",
    },
    { "<leader>Dc", function() require("dap").continue() end, desc = "Continue Debugging" },
    { "<leader>Di", function() require("dap").step_into() end, desc = "Step Into" },
    { "<leader>Do", function() require("dap").step_over() end, desc = "Step Over" },
    { "<leader>DO", function() require("dap").step_out() end, desc = "Step Out" },
    { "<leader>Dp", function() require("dap").pause() end, desc = "Pause Debugging" },
    {
      "<leader>De",
      function()
        require("dapui").eval()
      end,
      desc = "Evaluate Expression",
      mode = { "n", "x" },
    },
    { "<leader>Dr", function() require("dap").repl.toggle() end, desc = "Toggle Debug REPL" },
    { "<leader>Du", function() require("dapui").toggle() end, desc = "Toggle Debug UI" },
    { "<leader>Dt", function() require("dap").terminate() end, desc = "Terminate Debugging" },
    { "<leader>Dm", function() require("dap-python").test_method() end, desc = "Debug Test Method" },
    { "<leader>DC", function() require("dap-python").test_class() end, desc = "Debug Test Class" },
  },
  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    require("dap-python").setup("uv")
    dapui.setup()
    require("nvim-dap-virtual-text").setup()

    dap.listeners.after.event_initialized.dapui_config = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated.dapui_config = function()
      dapui.close()
    end
    dap.listeners.before.event_exited.dapui_config = function()
      dapui.close()
    end
  end,
}
