function ColorMyPencils(color)
	color = color or "solarized-osaka"
	vim.cmd.colorscheme(color)

	vim.api.nvim_set_hl(0, "Normal", { bg = "#1e1e1e" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1e1e1e" })
end

return {

    {
        "erikbackman/brightburn.vim",
    },

    {
        "folke/tokyonight.nvim",
        lazy = false,
        opts = {},
        config = function()
            ColorMyPencils()
        end
    },
    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        config = function()
            require("gruvbox").setup({
                terminal_colors = true, -- add neovim terminal colors
                undercurl = true,
                underline = false,
                bold = true,
                italic = {
                    strings = false,
                    emphasis = false,
                    comments = false,
                    operators = false,
                    folds = false,
                },
                strikethrough = true,
                invert_selection = false,
                invert_signs = false,
                invert_tabline = false,
                invert_intend_guides = false,
                inverse = true, -- invert background for search, diffs, statuslines and errors
                contrast = "", -- can be "hard", "soft" or empty string
                palette_overrides = {},
                overrides = {},
                dim_inactive = false,
                transparent_mode = false,
            })
        end,
    },
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                -- your configuration comes here
                -- or leave it empty to use the default settings
                style = "storm", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
                transparent = true, -- Enable this to disable setting the background color
                terminal_colors = true, -- Configure the colors used when opening a `:terminal` in Neovim
                styles = {
                    -- Style to be applied to different syntax groups
                    -- Value is any valid attr-list value for `:help nvim_set_hl`
                    comments = { italic = false },
                    keywords = { italic = false },
                    -- Background styles. Can be "dark", "transparent" or "normal"
                    sidebars = "dark", -- style for sidebars, see below
                    floats = "dark", -- style for floating windows
                },
            })
        end
    },

    {
        "rose-pine/neovim",
        name = "rose-pine",
        config = function()
            require('rose-pine').setup({
                disable_background = true,
                styles = {
                    italic = false,
                },
            })

            ColorMyPencils();
        end
    },
    {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,         -- fundo transparente pra casar com teu terminal
      terminal_colors = true,     -- cores no :terminal
      styles = {
        comments = { italic = true },
        keywords = { italic = true },
        functions = {},
        variables = {},
        sidebars = "dark",        -- qf/help e afins
        floats = "dark",          -- janelas flutuantes
      },
      sidebars = { "qf", "help", "neo-tree" }, -- mantém barras laterais consistentes
    },
    config = function(_, opts)
      require("solarized-osaka").setup(opts)
      -- Se teu “Osaka Jade” no SO/terminal for escuro, mantém background 'dark'
      vim.o.background = "dark"
      -- Aplica o colorscheme
      vim.cmd.colorscheme("solarized-osaka")
      -- Ajustes finos de transparência/popup sem “caixa preta”
      local function clear(group) pcall(vim.api.nvim_set_hl, 0, group, { bg = "none" }) end
      for _, g in ipairs({
        "Normal", "NormalNC", "NormalFloat", "SignColumn",
        "StatusLineNC", "CursorLine", "CursorLineNr",
        "LineNr", "FoldColumn", "WinSeparator",
        "TelescopeNormal", "TelescopeBorder", "FloatBorder",
      }) do clear(g) end
    end
  },


}
