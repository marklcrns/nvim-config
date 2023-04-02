return function()
  -- LSP Servers:
  -- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
  require("mason-lspconfig").setup({
    automatic_installation = true,
  })
end
