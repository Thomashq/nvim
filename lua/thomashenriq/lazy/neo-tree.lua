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
    },
    config = function(_, opts)
      require("neo-tree").setup(opts)
      -- Abrir ao entrar no Vim se nenhum arquivo específico foi passado
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          -- Se abriu um diretório, abre Neo-tree nele
          local is_dir = vim.fn.isdirectory(data.file) == 1
          if is_dir then
            vim.cmd.cd(data.file)
          end
          -- Evita abrir em casos como git commit, etc.
          local args = vim.fn.argv()
          if #args == 0 or is_dir then
            require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
          end
        end,
      })
    end,
  },
}

