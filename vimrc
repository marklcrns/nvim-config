execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/utils.vim'

let g:enable_format_on_save= v:true
" Must set proper snippet engine in /lua/user/plugins/nvim-cmp.lua
" and modify snippet engine in neogen
" options: ultisnips, luasnip
let g:snippet_engine = 'ultisnips'

" Enable this to disable cpu intensive plugins/modules
let g:low_performance_mode = g:ReadCacheFromDataDir('low_performance_mode', v:false) == 0 ? v:false : v:true

" DEPRECTED: by xiyaowong/transparent.nvim
" " let g:transparent_enabled = v:false
" if !exists('g:neovide') && !exists('g:Gui') && !exists('g:GuiLoaded') && !has('gui_running') && !has('gui')
"   let g:transparent_enabled = v:true
" else
"   let g:transparent_enabled = v:false
" endif




" Load core files. Will be deprecated soon!
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/rtp.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/core.vim'
