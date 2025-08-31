return {
  {
    "nvim-neotest/neotest",
    ft = { "cs" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "antoinemadec/FixCursorHold.nvim",
      "Issafalcon/neotest-dotnet",
    },
    config = function()
      local ok, neotest = pcall(require, "neotest")
      if not ok then return end

      neotest.setup({
        adapters = {
          require("neotest-dotnet")({
            discovery_root = "solution",
            dap = { justMyCode = false },
          }),
        },
      })

      -- atalhos
      vim.keymap.set("n","<leader>tn", function() neotest.run.run() end,                      { desc = "Test nearest (.NET)" })
      vim.keymap.set("n","<leader>tf", function() neotest.run.run(vim.fn.expand("%")) end,    { desc = "Test file (.NET)" })
      vim.keymap.set("n","<leader>ts", neotest.summary.toggle,                                { desc = "Test summary (.NET)" })
      vim.keymap.set("n","<leader>to", function() neotest.output.open({ enter = true }) end,  { desc = "Test output (.NET)" })
    end,
  },
}

