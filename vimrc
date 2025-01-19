execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/utils.vim'

let g:enable_format_on_save= v:true

" Must set proper snippet engine in /lua/user/plugins/nvim-cmp.lua
" and modify snippet engine in neogen
" options: ultisnips, luasnip
let g:snippet_engine = 'luasnip'

" Enable ai code autosuggestions
let g:ai_enabled = v:true

" Enable this to disable cpu intensive plugins/modules (default: false)
let g:low_performance_mode = g:ReadCacheFromDataDir('low_performance_mode', v:false) == 0 ? v:false : v:true

" Load core files. Will be deprecated soon!
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/rtp.vim'
execute 'source' fnamemodify(expand('<sfile>'), ':h').'/core/core.vim'
