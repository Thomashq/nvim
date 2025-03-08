return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup {
      size = 15,
      open_mapping = [[<C-t>]],
      shade_terminals = true,
      direction = "horizontal"
    }
  end
}

