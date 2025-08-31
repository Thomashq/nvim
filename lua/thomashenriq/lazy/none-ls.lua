return {
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvimtools/none-ls-extras.nvim" },
    config = function()
      local null = require("null-ls")

      local sources = {}
      local ok_csharpier, csharpier = pcall(require, "none-ls.extras.formatting.csharpier")
      if ok_csharpier then
        table.insert(sources, csharpier)
      else
        table.insert(sources, null.builtins.formatting.dotnet_format)
      end

      null.setup({ sources = sources })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.cs",
        callback = function()
          pcall(vim.lsp.buf.format, { async = false })
        end,
      })
    end,
  },
}

