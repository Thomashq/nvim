return {
  {
    "mfussenegger/nvim-dap",
    ft = { "cs" },
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
    },
    config = function()
      local dap   = require("dap")
      local dapui = require("dapui")

      dapui.setup()
      pcall(function() require("nvim-dap-virtual-text").setup() end)

      local netcoredbg = vim.fn.exepath("netcoredbg")
      if netcoredbg == "" then
        vim.notify("netcoredbg não encontrado no PATH", vim.log.levels.WARN)
        netcoredbg = "netcoredbg"
      end

      dap.adapters.coreclr = {
        type = "executable",
        command = netcoredbg,
        args = { "--interpreter=vscode" },
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "Launch",
          request = "launch",
          program = function()
            local default = vim.fn.getcwd() .. "/bin/Debug/"
            return vim.fn.input("Path do .dll: ", default, "file")
          end,
        },
      }

      -- atalhos
      vim.keymap.set("n","<F5>",  function() dap.continue(); dapui.open() end, { desc = "DAP Continue" })
      vim.keymap.set("n","<S-F5>",function() dap.terminate(); dapui.close() end,{ desc = "DAP Stop" })
      vim.keymap.set("n","<F9>",  dap.toggle_breakpoint, { desc = "DAP Breakpoint" })
      vim.keymap.set("n","<F10>", dap.step_over,         { desc = "DAP Step Over" })
      vim.keymap.set("n","<F11>", dap.step_into,         { desc = "DAP Step Into" })
      vim.keymap.set("n","<F12>", dap.step_out,          { desc = "DAP Step Out" })
    end,
  },
}

