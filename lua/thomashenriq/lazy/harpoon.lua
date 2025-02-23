return {
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup()

      -- Adicionar arquivo à lista do Harpoon
      vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)

      -- Abrir o menu rápido do Harpoon
      vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

      -- Navegação entre arquivos marcados (seguindo a ordem no QWERTY)
      vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end)
      vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end)
      vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end)
      vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end)

      -- Alternar entre arquivos anteriores e seguintes no Harpoon
      vim.keymap.set("n", "<C-p>", function() harpoon:list():prev() end)
      vim.keymap.set("n", "<C-n>", function() harpoon:list():next() end)
    end,
  },
}

