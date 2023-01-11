-- Servers list:
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local api = vim.api
local lspconfig_ok, lspconfig = pcall(require, "lspconfig")
local lsp_format_ok, lsp_format = pcall(require, "lsp-format")

if not lspconfig_ok or lsp_format_ok then
  return
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

-- nvim-ufo yaml folding fix: https://github.com/kevinhwang91/nvim-ufo/issues/72
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

function _G.open_lsp_log()
  local path = vim.lsp.get_log_path()
  vim.cmd("edit " .. path)
end

vim.cmd("command! -nargs=0 LspLog call v:lua.open_lsp_log()")

local signs = {
  Error = " ",
  Warn = " ",
  Hint = " ",
  Info = " ",
}
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

vim.diagnostic.config({
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  virtual_text = {
    source = true,
  },
})

local on_attach = function(client, bufnr)
  -- disable formatting for LSP clients as this is handled by null-ls
  client.server_capabilities.documentFormattingProvider = false
  client.server_capabilities.documentRangeFormattingProvider = false

  -- Disable tsserver formatting for prettier/eslint managed by null-ls
  if client.name == "tsserver" then
    client.server_capabilities.documentFormattingProvider = false
  end

  -- -- Format on save
  -- if client.server_capabilities.documentFormattingProvider then
  --   api.nvim_create_autocmd('BufWritePre', {
  --     pattern = client.config.filetypes,
  --     callback = function()
  --       vim.lsp.buf.format({
  --         bufnr = bufnr,
  --         async = true,
  --       })
  --     end,
  --   })
  -- end
end

lspconfig.gopls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "gopls", "--remote=auto" },
  init_options = {
    usePlaceholders = true,
    completeUnimported = true,
  },
})

lspconfig.sumneko_lua.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = {
        enable = true,
        globals = { "vim", "packer_plugins" },
      },
      runtime = { version = "LuaJIT" },
      workspace = {
        library = vim.list_extend({ [vim.fn.expand("$VIMRUNTIME/lua")] = true }, {}),
      },
    },
  },
})

lspconfig.clangd.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = {
    "clangd",
    "--background-index",
    "--suggest-missing-includes",
    "--clang-tidy",
    "--header-insertion=iwyu",
    "--offset-encoding=utf-16",
  },
})

lspconfig.rust_analyzer.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    imports = {
      granularity = {
        group = "module",
      },
      prefix = "self",
    },
    cargo = {
      buildScripts = {
        enable = true,
      },
    },
    procMacro = {
      enable = true,
    },
  },
})

lspconfig.emmet_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less" },
})

-- For adding spellfiles into ltex dictionary
local path = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"
local words = {}

for word in io.open(path, "r"):lines() do
  table.insert(words, word)
end

lspconfig.ltex.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "ltex-ls" },
  filetypes = { "bib", "gitcommit", "markdown", "org", "norg", "plaintex", "rst", "rnoweb", "tex" },
  flags = { debounce_text_changes = 300 },
  settings = {
    ltex = {
      -- Disable MORFOLOGIK_RULE_EN_US to fallback to native spell checker
      -- https://neovim.discourse.group/t/ltex-ls-and-spelling-woes/1589/4
      language = "en-US",
      disabledRules = { ["en-US"] = { "PROFANITY", "MORFOLOGIK_RULE_EN_US" } },
      dictionary = { ["en-US"] = words },
    },
  },
})

lspconfig.eslint.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    codeActionOnSave = {
      enable = true,
      mode = "all",
    },
  },
})

local servers = {
  "dockerls",
  "pyright",
  "tsserver",
  "bashls",
  "yamlls",
  "html",
  "cssls", -- css-lsp: for css and scss
  "vimls",
  "texlab",
}

for _, server in ipairs(servers) do
  -- Disable tsserver linter, use eslint instead by null-ls
  if server == "tsserver" then
    lspconfig[server].setup({
      on_attach = on_attach,
      capabilities = capabilities,
      handlers = { ["textDocument/publishDiagnostics"] = function(...) end },
    })
  else
    lspconfig[server].setup({
      on_attach = on_attach,
      capabilities = capabilities,
    })
  end

  lspconfig[server].setup({
    on_attach = on_attach,
    capabilities = capabilities,
  })
end

-- NOTE: Mappings Moved to keybinds.vim
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
-- local opts = { noremap=true, silent=true }
-- vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
-- vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
-- vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
-- vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)
