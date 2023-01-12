local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions

-- Ref: https://github.com/majamin/neovim-config/blob/master/lua/user/config/null-ls.lua
local sources = {
  -- Python
  formatting.black,
  -- C, C++, C#, Java, Cuda
  formatting.clang_format,
  -- Latex
  -- https://github.com/cmhughes/latexindent.pl/releases/tag/V3.9.3
  formatting.latexindent,
  -- HTML, JS, CSS
  -- formatting.prettierd,
  formatting.eslint_d,
  -- Rust,
  formatting.rustfmt,
  -- Lua
  formatting.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),
  -- Shell (bash, etc.)
  formatting.shfmt,
  -- Git code actions
  code_actions.gitsigns,
}

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
  debug = true,
  sources = sources,
  on_attach = function(client, bufnr)
    if client.server_capabilities.documentFormattingProvider then
      vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format({ bufnr = bufnr })
        end,
      })
    end
  end,
  -- clangd fix
  -- Ref: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428#issuecomment-1120578988
  -- Make sure to configure nvim-lspconfig clangd as well https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428#issuecomment-1120166948
  on_init = function(new_client, _)
    new_client.offset_encoding = "utf-16"
  end,
})
