-- default options
indent_levels = 30;
indent_guide_size = 1;
indent_start_level = 1;
indent_enable = true;
indent_space_guides = true;
indent_tab_guides = true;
indent_soft_pattern = '\\s';
exclude_filetypes = {'help','dashboard','dashpreview','NvimTree','vista','sagahover'};
even_colors = { fg='#2a3834',bg='#332b36' };
odd_colors = {fg='#332b36',bg='#2a3834'};

require('indent_guides').setup({
  exclude_filetypes = {
    'help', 'man', 'fern', 'defx', 'denite', 'denite-filter', 'startify',
    'vista', 'vista_kind', 'tagbar', 'lsp-hover', 'clap_input', 'fzf',
    'any-jump', 'gina-status', 'gina-commit', 'gina-log', 'minimap',
    'quickpick-filter', 'lsp-quickpick-filter', 'calendar', 'coc-explorer',
    'dashboard', 'codi', 'which_key', 'taskreport', 'floaterm'
  };
})
