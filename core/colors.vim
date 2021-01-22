" Highlights: Tabline {{{
" ----------------------------------------------------------------------------
" TabLineFill: Tab pages line, where there are no labels
hi TabLineFill ctermfg=234 ctermbg=236 guifg=#1C1C1C guibg=#303030 cterm=NONE gui=NONE
" TabLine: Not-active tab page label
hi TabLine     ctermfg=243 ctermbg=236 guifg=#767676 guibg=#303030 cterm=NONE gui=NONE
" TabLineSel: Active tab page label
hi TabLineSel  ctermfg=241 ctermbg=234 guifg=#626262 guibg=#1C1C1C cterm=NONE gui=NONE
" Custom
highlight TabLineSelShade  ctermfg=235 ctermbg=234 guifg=#262626 guibg=#1C1C1C
highlight TabLineAlt       ctermfg=252 ctermbg=238 guifg=#D0D0D0 guibg=#444444
highlight TabLineAltShade  ctermfg=238 ctermbg=236 guifg=#444444 guibg=#303030
" }}}

" Highlights: Statusline {{{
highlight StatusLine   ctermfg=236 ctermbg=248 guifg=#30302c guibg=#a8a897 cterm=reverse gui=reverse
highlight StatusLineNC ctermfg=236 ctermbg=242 guifg=#30302c guibg=#666656 cterm=reverse gui=reverse

" Filepath color
highlight User1 guifg=#D7D7BC guibg=#30302c ctermfg=251 ctermbg=236
" Line and column information
highlight User2 guifg=#a8a897 guibg=#4e4e43 ctermfg=248 ctermbg=239
" Line and column corner arrow
highlight User3 guifg=#4e4e43 guibg=#30302c ctermfg=239 ctermbg=236
" Buffer # symbol and whitespace or syntax errors
highlight User4 guifg=#666656 guibg=#30302c ctermfg=242 ctermbg=236
" Write symbol
highlight User6 guifg=#cf6a4c guibg=#30302c ctermfg=167 ctermbg=236
" Paste symbol
highlight User7 guifg=#99ad6a guibg=#30302c ctermfg=107 ctermbg=236
" Syntax and whitespace
highlight User8 guifg=#ffb964 guibg=#30302c ctermfg=215 ctermbg=236
" }}}

" Highlights: General GUI {{{
" ----------------------------------------------------------------------------
" Ref: https://github.com/mhinz/vim-janah
highlight Comment guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE
" Transparent bg
" highlight Normal guibg=NONE ctermbg=NONE
" }}}

" Plugin: vim-gitgutter {{{
" ----------------------------------------------------------------------------
highlight! GitGutterAdd ctermfg=22 guifg=#008500 ctermbg=234 guibg=NONE
highlight! GitGutterChange ctermfg=58 guifg=#808200 ctermbg=234 guibg=NONE
highlight! GitGutterDelete ctermfg=52 guifg=#800000 ctermbg=234 guibg=NONE
highlight! GitGutterChangeDelete ctermfg=52 guifg=#800000 ctermbg=234 guibg=NONE
" }}}

" Plugin: vim-signature {{{
highlight! SignatureMarkText    ctermfg=11 guifg=#756207 ctermbg=234 guibg=#1c1c1c
highlight! SignatureMarkerText  ctermfg=12 guifg=#4EA9D7 ctermbg=234 guibg=#1c1c1c
" }}}

" Plugin: vim-choosewin {{{
" ----------------------------------------------------------------------------
let g:choosewin_color_label = {
			\ 'cterm': [  75, 233 ], 'gui': [ '#7f99cd', '#000000' ] }
let g:choosewin_color_label_current = {
			\ 'cterm': [ 228, 233 ], 'gui': [ '#D7D17C', '#000000' ] }
let g:choosewin_color_other = {
			\ 'cterm': [ 235, 235 ], 'gui': [ '#232323', '#000000' ] }
" }}}

" Plugin: Fern.vim {{{
" ----------------------------------------------------------------------------
highlight FernGitStatusBracket guifg=#6c7a80 ctermfg=NONE
highlight FernGitStatusIndex guifg=#b5bd68 guibg=NONE
highlight FernGitStatusWorktree guifg=#cc6666 guibg=NONE
highlight FernGitStatusUnmerged guifg=#232c31 guibg=NONE
highlight FernGitStatusUntracked guifg=#6c7a80 guibg=NONE
highlight FernGitStatusIgnored guifg=#6c7a80 guibg=NONE
" }}}

" Plugins: Coc {{{
" ----------------------------------------------------------------------------
highlight CocCursorRange guibg=#b16286 guifg=#ebdbb2
highlight default CocHighlightText  guibg=#725972 ctermbg=96
highlight CocWarningSign  ctermfg=32 ctermbg=NONE guifg=#0087d7 guibg=NONE

" Coc-yank highlight
highlight HighlightedyankRegion term=bold ctermbg=0 guibg=#d0d0d0
" }}}

" GetColorSynatxGroup
" ---------------------------------------------------------
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
			\ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
			\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>


