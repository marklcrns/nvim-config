
let g:indent_guides_auto_colors = 0
let g:indent_guides_tab_guides = 0
let g:indent_guides_color_change_percent = 3
let g:indent_guides_default_mapping = 0
let g:indent_guides_guide_size = 1
let g:indent_guides_exclude_filetypes =
    \ [ 'help', 'terminal', 'defx', 'denite', 'nerdtree',
    \ 'startify', 'tagbar', 'vista_kind', 'vista', 'fzf',
    \ 'codi', 'which_key', 'calendar', 'coc', 'floaterm',
    \ 'any-jump', 'coc-explorer', 'clap_input', 'dashboard',
    \ 'fern' ]

" Manual auto disable if exclude does not work
augroup ManualIndentGuideToggle
  " Any-jump
  autocmd!
  autocmd Filetype any-jump
    \ autocmd BufWinEnter <buffer> IndentGuidesDisable
  autocmd Filetype any-jump
    \ autocmd BufWinLeave <buffer> IndentGuidesEnable
  autocmd BufEnter any-jump.* IndentGuidesDisable
  autocmd BufLeave any-jump.* IndentGuidesEnable
augroup END

autocmd user_events FileType * ++once IndentGuidesEnable
