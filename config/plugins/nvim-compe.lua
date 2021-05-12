-- local capabilities = vim.lsp.protocol.make_client_capabilities()
-- capabilities.textDocument.completion.completionItem.snippetSupport = true
-- capabilities.textDocument.completion.completionItem.resolveSupport = {
--   properties = {
--     'documentation',
--     'detail',
--     'additionalTextEdits',
--   }
-- }
-- 
-- require'lspconfig'.rust_analyzer.setup {
--   capabilities = capabilities,
-- }
-- 
-- require'lspconfig'.clangd.setup {
--   capabilities = capabilities,
-- }
-- 
-- require'lspconfig'.jdtls.setup {
--   capabilities = capabilities,
-- }

require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 3;
  preselect = 'always';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 50;
  max_kind_width = 50;
  max_menu_width = 50;
  documentation = true;

  source = {
    path = {
      kind = "",
      ignored_filetypes = {'clap_input'}
    },
    buffer = {
      kind = "",
      ignored_filetypes = {'clap_input'}
    },
    calc = {
      kind = "",
      ignored_filetypes={'clap_input'}
    },
    nvim_lsp = {
      kind = "",
      ignored_filetypes={'clap_input'}
    },
    nvim_lua = {
      kind = "",
      ignored_filetypes={'clap_input'}
    },
    spell = {
      kind = "",
      ignored_filetypes={'clap_input'}
    },
    ultisnips = {
      kind = "",
      ignored_filetypes={'clap_input'}
    },
    tabnine = {
      kind = "",
      priority = 50,
      show_prediction_strength = true,
      max_line = 1000,
      max_num_results = 6,
      ignored_filetypes= {'clap_input'},
      ignore_pattern = '[(]'
    },
    emoji = {
      kind = "ﲃ",
      filetypes={"markdown"},
      ignored_filetypes={'clap_input'}
    },
  },
}

