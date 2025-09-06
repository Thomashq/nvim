return {
  {
    "folke/snacks.nvim",
    config = function()
      require("snacks").setup({
        scroll       = { enabled = false }, -- como você pediu
        cursorline   = { enabled = true },
        statuscolumn = { enabled = true },
        dashboard    = { enabled = true },
        indent       = { enabled = true },
      })
    end,
  },
}
