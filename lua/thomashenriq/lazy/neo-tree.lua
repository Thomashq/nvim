return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      window = { width = 32 },
      filesystem = {
        follow_current_file = { enabled = true },
        filtered_items = { hide_dotfiles = false, hide_gitignored = false },
      },
      sources = { "filesystem", "buffers", "git_status" },
      -- Mapeamentos dentro do Neo-tree
      window = {
        mappings = {
          ["<cr>"] = "open",       -- enter abre arquivo
          ["l"]    = "open",       -- l também abre
          ["h"]    = "close_node", -- h fecha diretório
          ["a"]    = "add",        -- criar arquivo/pasta
          ["d"]    = "delete",     -- deletar
          ["r"]    = "rename",     -- renomear
          ["c"]    = "copy",       -- copiar
          ["x"]    = "cut",        -- cortar
          ["p"]    = "paste",      -- colar
          ["q"]    = "close_window", -- fechar Neo-tree
        },
      },
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      close_if_last_window = true
      -- Atalhos globais para abrir Neo-tree
      vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Neo-tree Toggle" })
      vim.keymap.set("n", "<leader>o", "<cmd>Neotree focus<cr>",  { desc = "Neo-tree Focus" })

      -- Abrir ao entrar no Vim se nenhum arquivo específico foi passado
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          local is_dir = vim.fn.isdirectory(data.file) == 1
          if is_dir then
            vim.cmd.cd(data.file)
          end
          local args = vim.fn.argv()
          if #args == 0 or is_dir then
            require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
          end
        end,
      })
    end,
  },
}

