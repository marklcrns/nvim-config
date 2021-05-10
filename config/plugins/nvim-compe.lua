require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'always';
  throttle_time = 80;
  source_timeout = 200;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
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
      ignored_filetypes={'clap_input'}
    },
    emoji = {
      kind = "ﲃ",
      filetypes={"markdown"},
      ignored_filetypes={'clap_input'}
    },
  },
}

