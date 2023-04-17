let g:transparent_background = v:false
" if !exists('g:neovide') && !exists('g:Gui') && !exists('g:GuiLoaded') && !has('gui_running') && !has('gui')
"   let g:transparent_background = v:true
" else
"   let g:transparent_background = v:false
" endif
let g:enable_format_on_save= v:true

" Gui Fonts
let g:guifontsize = 12
" let g:guifont = 'Source\ Code\ Pro\ iCursive\ S12'
" let g:guifont = 'OperatorMono\ Nerd\ Font'
let g:guifont = 'VictorMono\ Nerd\ Font'

execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/rtp.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/core.vim'
