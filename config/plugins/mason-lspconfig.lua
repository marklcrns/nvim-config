-- LSP Servers:
-- https://github.com/williamboman/mason-lspconfig.nvim#available-lsp-servers
require("mason-lspconfig").setup({
  ensure_installed = {
    "sumneko_lua",
    "rust_analyzer",
    "yamlls",
    "emmet_ls",
    "bashls",
    "vimls",
    "clangd",
    "pyright",
    "dockerls",
    "html",
    "tsserver",
    "tailwindcss",
    "cssls", -- css-lsp
    "texlab",
    "ltex", -- ltex-ls
  },
  automatic_installation = true,
})
