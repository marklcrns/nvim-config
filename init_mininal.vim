let g:handle_plugins = 'disable'

" Custom settings enable
let g:custom_colorscheme = 1
let g:custom_colorscheme_persist = 0
let g:custom_statusline_enable = 1
let g:custom_tabline_enable = 1
let g:custom_cursorline_enable = 1
let g:custom_cursorcolumn_enable = 0
let g:enable_format_on_save=1

" Gui Fonts
let g:guifontsize = 12
" let g:guifont = 'Source\ Code\ Pro\ iCursive\ S12'
" let g:guifont = 'OperatorMono\ Nerd\ Font'
let g:guifont = 'VictorMono\ Nerd\ Font'

execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/rtp.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/core.vim'
