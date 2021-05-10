" Disable expand trigger mapping to let nvim-compe handle the expand
let g:UltiSnipsExpandTrigger = "<Nop>"
let g:UltiSnipsJumpForwardTrigger = "<C-j>"
let g:UltiSnipsJumpBackwardTrigger = "<C-k>"
let g:UltiSnipsSnippetDirectories = [
      \ $DATA_PATH . "/dein/repos/github.com/honza/vim-snippets/UltiSnips",
      \ $VIM_PATH . "/UltiSnips/"
      \ ]

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit = "vertical"

" Manual mapping of Visual and Selection
" snoremap <silent> <Tab> <Esc>:call UltiSnips#ExpandSnippet()<cr>
" xnoremap <silent> <Tab> :call UltiSnips#SaveLastVisualSelection()<cr>gvs

