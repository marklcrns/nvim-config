local mason_lspconfig_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_ok then
  return
end

-- LSP Servers:
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
mason_lspconfig.setup({
  automatic_installation = true,
})
