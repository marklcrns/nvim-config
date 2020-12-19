" Vim Colors
" ---------------------------------------------------------
highlight Whitespace ctermfg=238 guifg=#424450 guibg=NONE ctermbg=NONE
highlight VertSplit  ctermfg=Black  guifg=Black guibg=NONE ctermbg=NONE
highlight LineNr ctermbg=NONE guibg=NONE
highlight SignColumn ctermfg=187 ctermbg=NONE guifg=#ebdbb2 guibg=NONE guisp=NONE cterm=NONE gui=NONE
highlight Conceal guifg=#ebdbb2 guibg=NONE guisp=NONE gui=NONE cterm=NONE
" highlight MatchParen cterm=bold ctermbg=NONE ctermfg=magenta
highlight! link pythonSpaceError  NONE
highlight! link pythonIndentError NONE

" Transparent bg
highlight Normal guibg=NONE ctermbg=NONE

" Pmenu Colors
" ---------------------------------------------------------
" highlight PMenuSel ctermfg=252 ctermbg=106 guifg=#d0d0d0 guibg=#ba8baf guisp=#ba8baf cterm=NONE gui=NONE
" highlight Pmenu ctermfg=103 ctermbg=236 guifg=#9a9aba guibg=#34323e guisp=NONE cterm=NONE gui=NONE
" highlight PmenuSbar ctermfg=NONE ctermbg=234 guifg=NONE guibg=#212026 guisp=NONE cterm=NONE gui=NONE
" highlight PmenuSel ctermfg=NONE ctermbg=60 guifg=NONE guibg=#5e5079 guisp=NONE cterm=NONE gui=NONE
" highlight PmenuThumb ctermfg=NONE ctermbg=60 guifg=NONE guibg=#5d4d7a guisp=NONE cterm=NONE gui=NONE

" Coc setting
" ---------------------------------------------------------
highlight CocCursorRange guibg=#b16286 guifg=#ebdbb2
highlight default CocHighlightText  guibg=#725972 ctermbg=96
highlight CocWarningSign  ctermfg=32 ctermbg=NONE guifg=#0087d7 guibg=NONE

" Coc-yank highlight
highlight HighlightedyankRegion term=bold ctermbg=0 guibg=#d0d0d0

" GitGutter
" ---------------------------------------------------------
highlight GitGutterAdd ctermfg=22 guifg=#006000 ctermbg=NONE guibg=NONE
highlight GitGutterChange ctermfg=58 guifg=#5F6000 ctermbg=NONE guibg=NONE
highlight GitGutterDelete ctermfg=52 guifg=#600000 ctermbg=NONE guibg=NONE
highlight GitGutterChangeDelete ctermfg=52 guifg=#600000 ctermbg=NONE guibg=NONE

" Buftabline highlight
" ---------------------------------------------------------
highlight BufTabLineCurrent ctermbg=96 guibg=#5d4d7a

" Fern.vim
" ---------------------------------------------------------
highlight FernGitStatusBracket guifg=#6c7a80 ctermfg=NONE
highlight FernGitStatusIndex guifg=#b5bd68 guibg=NONE
highlight FernGitStatusWorktree guifg=#cc6666 guibg=NONE
highlight FernGitStatusUnmerged guifg=#232c31 guibg=NONE
highlight FernGitStatusUntracked guifg=#6c7a80 guibg=NONE
highlight FernGitStatusIgnored guifg=#6c7a80 guibg=NONE

" Janah Color Scheme
" ---------------------------------------------------------
" Repo: https://github.com/mhinz/vim-janah
highlight Comment guifg=#585858 ctermfg=240 guibg=NONE ctermbg=NONE gui=NONE cterm=NONE

" Vim-indent-guides
" NOTE: g:indent_guides_auto_colors must be 0
" ---------------------------------------------------------
highlight IndentGuidesOdd  guibg=#262626 ctermbg=235
highlight IndentGuidesEven guibg=#303030 ctermbg=236

" Braceless.vim
" ---------------------------------------------------------
highlight BracelessIndent ctermfg=8 ctermbg=66 cterm=NONE guibg=#88C0D0

" Whichkey.vim
" ---------------------------------------------------------
highlight WhichKeySeperator guibg=NONE ctermbg=NONE guifg=#303030 ctermfg=02

" GetColorSynatxGroup
" ---------------------------------------------------------
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

