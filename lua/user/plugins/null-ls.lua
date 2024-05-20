-- return function()
--   local null_ls = require("null-ls")
--
--   -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
--   local formatting = null_ls.builtins.formatting
--   -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
--   local diagnostics = null_ls.builtins.diagnostics
--   local code_actions = null_ls.builtins.code_actions
--
--   -- Ref: https://github.com/majamin/neovim-config/blob/master/lua/user/config/null-ls.lua
--   local sources = {
--     -- Python
--     formatting.black,
--     -- C, C++, C#, Java, Cuda
--     formatting.clang_format,
--     -- JSON
--     formatting.jq,
--     -- Latex
--     -- https://github.com/cmhughes/latexindent.pl/releases/tag/V3.9.3
--     formatting.latexindent.with({ extra_args = { "-g", "/dev/null" } }),
--     -- HTML, JS, CSS
--     -- formatting.prettierd,
--     formatting.eslint,
--     -- formatting.eslint_d,
--     -- Rust,
--     formatting.rustfmt,
--     -- Lua
--     formatting.stylua.with({ extra_args = { "--indent-type", "Spaces", "--indent-width", "2" } }),
--     -- Shell (bash, etc.)
--     formatting.shfmt,
--     code_actions.shellcheck,
--     -- Git code actions
--     code_actions.gitsigns.with({
--       config = {
--         filter_actions = function(title)
--           return title:lower():match("blame") == nil -- filter out blame actions
--         end,
--       },
--     }),
--   }
--
--   local lsp_formatting = function(bufnr)
--     vim.lsp.buf.format({
--       filter = function(client)
--         -- apply whatever logic you want (in this example, we'll only use null-ls)
--         return client.name == "null-ls"
--       end,
--       bufnr = bufnr,
--       async = true,
--     })
--   end
--
--   -- if you want to set up formatting on save, you can use this as a callback
--   local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
--
--   -- add to your shared on_attach callback
--   local on_attach = function(client, bufnr)
--     if client.supports_method("textDocument/formatting") then
--       vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
--       vim.api.nvim_create_autocmd("BufWritePre", {
--         group = augroup,
--         buffer = bufnr,
--         callback = function()
--           -- format  if has changes
--           if vim.api.nvim_buf_get_option(bufnr, "modified") then
--             lsp_formatting(bufnr)
--           end
--         end,
--       })
--     end
--   end
--
--   null_ls.setup({
--     debug = true,
--     sources = sources,
--     on_attach = on_attach,
--     -- clangd fix
--     -- Ref: https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428#issuecomment-1120578988
--     -- Make sure to configure nvim-lspconfig clangd as well https://github.com/jose-elias-alvarez/null-ls.nvim/issues/428#issuecomment-1120166948
--     on_init = function(new_client, _)
--       new_client.offset_encoding = "utf-16"
--     end,
--   })
-- end

return function()
  local nls = require("null-ls")
  local builtins = nls.builtins

  nls.setup({
    sources = {
      builtins.formatting.prettier,
    },
  })
end
