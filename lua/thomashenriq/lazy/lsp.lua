return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "stevearc/conform.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },

  config = function()
    -- ========= Conform (formatters) =========
    require("conform").setup({
      formatters_by_ft = {
        -- usa csharpier se instalado; fallback para dotnet-format
        cs = { "csharpier", "dotnet_format" },
        -- mantém o resto como já configuras noutros arquivos, se houver
      },
      -- opcional: formata ao salvar .cs
      format_on_save = function(bufnr)
        local ft = vim.bo[bufnr].filetype
        if ft == "cs" then
          return { lsp_fallback = true, timeout_ms = 2000 }
        end
      end,
    })

    -- ========= LSP base =========
    local cmp = require("cmp")
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities()
    )

    require("fidget").setup({})
    require("mason").setup()

    local lspconfig = require("lspconfig")
    local util = lspconfig.util

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "omnisharp",
        "clangd",
      },
      handlers = {
        -- default
        function(server_name)
          lspconfig[server_name].setup({ capabilities = capabilities })
        end,

        -- Zig (como você já tinha)
        zls = function()
          lspconfig.zls.setup({
            root_dir = util.root_pattern(".git", "build.zig", "zls.json"),
            settings = {
              zls = {
                enable_inlay_hints = true,
                enable_snippets = true,
                warn_style = true,
              },
            },
          })
          vim.g.zig_fmt_parse_errors = 0
          vim.g.zig_fmt_autosave = 0
        end,

        -- Lua (como você já tinha)
        ["lua_ls"] = function()
          lspconfig.lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = { version = "Lua 5.1" },
                diagnostics = {
                  globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                },
              },
            },
          })
        end,

        -- ======== C# / OmniSharp (custom) ========
        ["omnisharp"] = function()
          -- raiz por .sln/.csproj (fallback .git/cwd)
          local root_markers = { "global.json", "*.sln", "*.csproj", ".git" }
          local function root_dir(fname)
            return util.root_pattern(unpack(root_markers))(fname)
                or util.find_git_ancestor(fname)
                or vim.loop.cwd()
          end

          lspconfig.omnisharp.setup({
            capabilities = capabilities,
            root_dir = root_dir,
            enable_roslyn_analyzers = true,
            organize_imports_on_format = true,
            enable_import_completion = true,
            sdk_include_prereleases = true,
            -- mantém o teu on_attach global, se tiver; aqui não sobreponho
          })
        end,
      },
    })

    -- ========= nvim-cmp =========
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    cmp.setup({
      snippet = {
        expand = function(args) require("luasnip").lsp_expand(args.body) end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
        ["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
        ["<C-y>"] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
      }),
      sources = cmp.config.sources({
        { name = "copilot", group_index = 2 },
        { name = "nvim_lsp" },
        { name = "luasnip" },
      }, {
        { name = "buffer" },
      }),
    })

    -- ========= Diagnostics UI =========
    vim.diagnostic.config({
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end,
}

