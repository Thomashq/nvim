return {
  {
  "famiu/bufdelete.nvim",
  config = function()
    -- Atalhos para fechar buffer sem fechar janela
    vim.keymap.set("n", "<leader>bd", "<cmd>Bdelete<CR>", { desc = "Fechar buffer (keep window)" })
    -- Fechar e ir pro próximo buffer (estilo IDE)
    vim.keymap.set("n", "<leader>bx", function()
      require("bufdelete").bufdelete(0, true)
      vim.cmd("BufferLineCycleNext")
    end, { desc = "Fechar buffer e ir pro próximo" })
  end
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      -- garante que a tabline apareça quando fizer sentido
      vim.o.showtabline = 2

      require("bufferline").setup({
        options = {
          mode = "buffers",
          diagnostics = "nvim_lsp",
          separator_style = "slant",
          show_buffer_close_icons = true,
          show_close_icon = false,
          always_show_bufferline = true,

          -- 🔑 Aqui é o pulo do gato: não cobrir o Neo-Tree
          offsets = {
            {
              filetype = "neo-tree",     -- filetype do Neo-Tree
              text = "Explorer",
              text_align = "center",
              separator = true,          -- desenha um separador na borda do editor
              highlight = "Directory",
            },
          },

          -- (opcional) Esconde em alguns buffers especiais
          custom_filter = function(bufnr, buf_list)
            local ft = vim.bo[bufnr].filetype
            local ban = { "neo-tree", "qf", "help", "alpha", "starter", "dashboard" }
            for _, b in ipairs(ban) do
              if ft == b then return false end
            end
            return true
          end,
        },
      })

      -- navegação estilo IDE
      vim.keymap.set("n", "<S-l>", ":BufferLineCycleNext<CR>", { silent = true, desc = "Próximo buffer" })
      vim.keymap.set("n", "<S-h>", ":BufferLineCyclePrev<CR>", { silent = true, desc = "Buffer anterior" })
    end,
  },
}
