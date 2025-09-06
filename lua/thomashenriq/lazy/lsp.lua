return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "stevearc/conform.nvim",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "j-hui/fidget.nvim",
      -- opcional DAP: "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui",
    },
    config = function()
      -- Conform (formatters)
      require("conform").setup({
        formatters_by_ft = {
          cs  = { "csharpier", "dotnet_format" },
          c   = { "clang_format" },
          cpp = { "clang_format" },
        },
        format_on_save = function(bufnr)
          local ft = vim.bo[bufnr].filetype
          if ft == "cs" or ft == "c" or ft == "cpp" then
            return { lsp_fallback = true, timeout_ms = 2000 }
          end
        end,
      })

      require("fidget").setup({})
      require("mason").setup()

      local cmp_cap = require("cmp_nvim_lsp").default_capabilities()
      local lspconfig = require("lspconfig")
      local util = lspconfig.util

      -- on_attach + keymaps
      local function on_attach(client, bufnr)
        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end
        map("n", "gd", vim.lsp.buf.definition, "Goto Definition")
        map("n", "gD", vim.lsp.buf.declaration, "Goto Declaration")
        map("n", "gi", vim.lsp.buf.implementation, "Goto Implementation")
        map("n", "gr", vim.lsp.buf.references, "References")
        map("n", "K",  vim.lsp.buf.hover, "Hover Doc")
        map("n", "<leader>rn", vim.lsp.buf.rename, "Rename")
        map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")
        map("n", "<leader>f", function() require("conform").format({ async = true }) end, "Format")
        map("n", "<leader>e", vim.diagnostic.open_float, "Line Diagnostics")
        map("n", "[d", vim.diagnostic.goto_prev, "Prev Diagnostic")
        map("n", "]d", vim.diagnostic.goto_next, "Next Diagnostic")

        if vim.lsp.inlay_hint and client.server_capabilities.inlayHintProvider then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end

      vim.diagnostic.config({
        virtual_text = { spacing = 2, prefix = "●" },
        float = { border = "rounded", source = "if_many" },
        severity_sort = true,
      })

      require("mason-lspconfig").setup({
        ensure_installed = {
          "omnisharp",
          "clangd",
          "lua_ls",
          -- bins úteis instalados via mason:
          "csharpier",
          "clang-format",
          "codelldb",
        },
        handlers = {
          -- default
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = cmp_cap,
              on_attach = on_attach,
            })
          end,

          -- clangd (C/C++)
          ["clangd"] = function()
            local clang_cap = vim.tbl_deep_extend("force", {}, cmp_cap, { offsetEncoding = { "utf-16" } })
            lspconfig.clangd.setup({
              capabilities = clang_cap,
              on_attach = on_attach,
              cmd = { "clangd", "--background-index", "--clang-tidy", "--completion-style=detailed", "--header-insertion=never" },
              root_dir = function(fname)
                return util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname)
                    or util.find_git_ancestor(fname)
                    or vim.loop.cwd()
              end,
            })
          end,

          -- OmniSharp (C#)
          ["omnisharp"] = function()
            local function root_dir(fname)
              return util.root_pattern("global.json", "*.sln", "*.csproj", ".git")(fname)
                  or util.find_git_ancestor(fname)
                  or vim.loop.cwd()
            end
            lspconfig.omnisharp.setup({
              capabilities = cmp_cap,
              on_attach = function(client, bufnr)
                if client.server_capabilities.semanticTokensProvider
                   and client.server_capabilities.semanticTokensProvider.legend then
                  client.server_capabilities.semanticTokensProvider.full = true
                end
                on_attach(client, bufnr)
                local function map(lhs, rhs, desc)
                  vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
                end
                map("<leader>oi", function()
                  vim.lsp.buf.execute_command({
                    command = "omnisharp/organizeImports",
                    arguments = { { FileName = vim.uri_from_bufnr(bufnr) } },
                  })
                end, "Organize Imports (OmniSharp)")
              end,
              root_dir = root_dir,
              enable_roslyn_analyzers = true,
              organize_imports_on_format = false,
              enable_import_completion = true,
              sdk_include_prereleases = true,
            })
          end,

          -- Lua
          ["lua_ls"] = function()
            lspconfig.lua_ls.setup({
              capabilities = cmp_cap,
              on_attach = on_attach,
              settings = {
                Lua = {
                  diagnostics = { globals = { "vim" } },
                  workspace = { checkThirdParty = false },
                },
              },
            })
          end,
        },
      })

      -- nvim-cmp básico
      local cmp = require("cmp")
      cmp.setup({
        snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
        mapping = cmp.mapping.preset.insert({
          ["<C-n>"] = cmp.mapping.select_next_item(),
          ["<C-p>"] = cmp.mapping.select_prev_item(),
          ["<C-y>"] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}

