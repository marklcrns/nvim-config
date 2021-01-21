let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_auto_colors = 0
let g:indent_guides_color_change_percent = 3
let g:indent_guides_default_mapping = 0
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes = [
			\ 'help', 'man', 'fern', 'defx', 'denite', 'denite-filter', 'startify',
			\ 'vista', 'vista_kind', 'tagbar', 'lsp-hover', 'clap_input', 'fzf',
			\ 'any-jump', 'gina-status', 'gina-commit', 'gina-log', 'minimap',
			\ 'quickpick-filter', 'lsp-quickpick-filter', 'calendar', 'coc-explorer',
			\ 'dashboard', 'codi', 'which_key'
			\ ]

let g:indent_guides_start_level = 1
let g:indent_guides_space_guides = 1
let g:indent_guides_tab_guides = 1
" Override tab display chars
set listchars+=tab:\ \ 

autocmd user_events FileType * ++once IndentGuidesEnable
