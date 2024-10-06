return function()
  require("conform").setup({
    formatters_by_ft = {
      lua = { "stylua" },
      -- Conform will run multiple formatters sequentially
      python = { "isort", "black" },
      -- Use a sub-list to run only the first available formatter
      javascript = { "prettierd", "prettier", stop_after_first = true },
      javascriptreact = { "prettierd", "prettier", stop_after_first = true },
      typescript = { "prettierd", "prettier", stop_after_first = true },
      typescriptreact = { "prettierd", "prettier", stop_after_first = true },
      css = { "prettierd", "prettier", stop_after_first = true },
      scss = { "prettierd", "prettier", stop_after_first = true },
      sass = { "prettierd", "prettier", stop_after_first = true },
      html = { "prettierd", "prettier", stop_after_first = true },
      markdown = { "prettierd", "prettier", stop_after_first = true },
      json = { "jq" },
      rust = { "rustfmt" }
    },
    default_format_opts = {
      lsp_format = "fallback",
    },
    format_on_save = false,
    format_after_save = false,
    -- Conform will notify you when a formatter errors
    notify_on_error = true,
    -- Conform will notify you when no formatters are available for the buffer
    notify_no_formatters = true,
  })

  vim.opt.formatexpr = "v:lua.require'conform'.formatexpr()"

  Config.common.au.declare_group("user.conform.nvim", {}, {
    {
      "LspAttach",
      callback = function()
        vim.opt_local.formatexpr = "v:lua.require'conform'.formatexpr()"
      end,
    }
  })
end
