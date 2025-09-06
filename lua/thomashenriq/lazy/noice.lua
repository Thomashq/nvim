return {
  -- 1) Barra de comandos flutuante (bonita) ao pressionar ":"
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify", -- opcional, mas deixa as notificações lindas
    },
    config = function()
      require("noice").setup({
        presets = {
          bottom_search = false,     -- não usar a barra embaixo
          command_palette = true,    -- integra entradas num layout “palette”
          long_message_to_split = true,
          lsp_doc_border = true,
        },
        cmdline = {
          enabled = true,
          view = "cmdline_popup",    -- 💡 popup central ao digitar ":"
          format = {
            cmdline = { pattern = "^:", icon = "", lang = "vim" },
            search = { kind = "search", pattern = "^/", icon = "", lang = "regex" },
          },
        },
        views = {
          cmdline_popup = {
            position = { row = "30%", col = "50%" },
            size = { width = 60, height = "auto" },
            border = { style = "rounded", padding = { 0, 1 } },
          },
          popupmenu = { -- menu de completions da cmdline
            relative = "editor",
            position = { row = "30%", col = "50%" },
            size = { width = 60, height = 10 },
            border = { style = "rounded", padding = { 0, 1 } },
          },
        },
      })
      -- Usa o notify como provedor de notificações (bonitinho)
      vim.notify = require("notify")
    end,
  },

  -- 2) Autocomplete na cmdline ":" e nas buscas "/"
  {
    "hrsh7th/nvim-cmp",
    event = "CmdlineEnter",
    dependencies = { "hrsh7th/cmp-cmdline" },
    config = function()
      local cmp = require("cmp")

      -- Autocomplete para ":" (comandos)
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "cmdline" } },
        view = { entries = "custom" },
      })

      -- Autocomplete para "/" (busca no buffer)
      cmp.setup.cmdline("/", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = { { name = "buffer" } },
      })
    end,
  },

  -- 3) Command Palette (lista/filtra comandos)
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<leader>:", "<cmd>Telescope commands<CR>", desc = "Command Palette (comandos)" },
      { "<leader>;", "<cmd>Telescope command_history<CR>", desc = "Histórico de comandos" },
    },
    config = function()
      require("telescope").setup({
        defaults = {
          sorting_strategy = "ascending",
          layout_config = { width = 0.9, height = 0.9, prompt_position = "top" },
        },
      })
    end,
  },
}

