" " let g:transparent_enable = v:false
" if !exists('g:neovide') && !exists('g:Gui') && !exists('g:GuiLoaded') && !has('gui_running') && !has('gui')
"   let g:transparent_enable = v:true
" else
"   let g:transparent_enable = v:false
" endif
let g:enable_format_on_save= v:true
" Must set proper snippet engine in /lua/user/plugins/nvim-cmp.lua
" and modify snippet engine in neogen
let g:snippet_engine = 'luasnip'

" Gui Fonts
let g:guifontsize = 12
" let g:guifont = 'Source\ Code\ Pro\ iCursive\ S12'
" let g:guifont = 'OperatorMono\ Nerd\ Font'
let g:guifont = 'VictorMono\ Nerd\ Font'

execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/rtp.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/core.vim'
