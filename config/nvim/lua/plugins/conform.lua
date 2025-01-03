local Plugin = {'stevearc/conform.nvim'}

Plugin.opts = {
  formatters_by_ft = {
      lua = { "stylua" },
      go = {"gofumpt"},
      python = { "isort", "black" },
      rust = { "rustfmt", lsp_format = "fallback" },
      javascript = { "prettierd", "prettier", stop_after_first = true },
    },
  format_on_save = {
     -- These options will be passed to conform.format()
    timeout_ms = 500,
    lsp_format = "fallback",
  }
}
return Plugin
