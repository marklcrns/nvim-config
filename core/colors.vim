" Core: Tabline {{{
" ----------------------------------------------------------------------------
" TabLineFill: Tab pages line, where there are no labels
hi TabLineFill ctermfg=234 ctermbg=236 guifg=#1C1C1C guibg=#303030 cterm=NONE gui=NONE
" TabLine: Not-active tab page label
hi TabLine     ctermfg=243 ctermbg=236 guifg=#767676 guibg=#303030 cterm=NONE gui=NONE
" TabLineSel: Active tab page label
hi TabLineSel     ctermfg=241 ctermbg=234 guifg=#626262 guibg=#1C1C1C cterm=NONE gui=NONE
hi TabLineSelSep  ctermfg=236 ctermbg=234 guifg=#303030 guibg=#1C1C1C
" Custom
hi TabLineSelShade  ctermfg=235 ctermbg=234 guifg=#262626 guibg=#1C1C1C
hi TabLineAlt       ctermfg=252 ctermbg=238 guifg=#D0D0D0 guibg=#444444
hi TabLineAltShade  ctermfg=238 ctermbg=236 guifg=#444444 guibg=#303030
" }}}

" Core: Statusline {{{
hi StatusLine   ctermfg=236 ctermbg=248 guifg=#30302c guibg=#a8a897 cterm=reverse gui=reverse
hi StatusLineNC ctermfg=236 ctermbg=242 guifg=#30302c guibg=#666656 cterm=reverse gui=reverse

" Filepath color
hi User1 guifg=#D7D7BC guibg=#30302c ctermfg=251 ctermbg=236
" Line and column information
hi User2 guifg=#a8a897 guibg=#4e4e43 ctermfg=248 ctermbg=239
" Line and column corner arrow
hi User3 guifg=#4e4e43 guibg=#30302c ctermfg=239 ctermbg=236
" Buffer # symbol and whitespace or syntax errors
hi User4 guifg=#666656 guibg=#30302c ctermfg=242 ctermbg=236
" Write symbol
hi User6 guifg=#cf6a4c guibg=#30302c ctermfg=167 ctermbg=236
" Paste symbol
hi User7 guifg=#99ad6a guibg=#30302c ctermfg=107 ctermbg=236
" Syntax and whitespace
hi User8 guifg=#ffb964 guibg=#30302c ctermfg=215 ctermbg=236
" }}}

" Plugin: indent_blankline {{{
highlight IndentBlanklineIndent1 guifg=#303030 gui=nocombine
highlight IndentBlanklineIndent2 guifg=#454545 gui=nocombine
highlight IndentBlanklineIndent3 guifg=#606060 gui=nocombine
highlight IndentBlanklineIndent4 guifg=#757575 gui=nocombine
highlight IndentBlanklineIndent5 guifg=#909090 gui=nocombine
" }}}

" Plugin: vim-choosewin {{{
let g:choosewin_color_label = {
      \ 'cterm': [  75, 233 ], 'gui': [ '#7f99cd', '#000000' ] }
let g:choosewin_color_label_current = {
      \ 'cterm': [ 228, 233 ], 'gui': [ '#D7D17C', '#000000' ] }
let g:choosewin_color_other = {
      \ 'cterm': [ 235, 235 ], 'gui': [ '#232323', '#000000' ] }
" }}}

" Plugin: vim-you-autocorrect {{{
highlight AutocorrectGood ctermfg=Yellow guifg=Yellow gui=undercurl
" }}}

" Plugin: nvim-ufo {{{
" hi default UfoFoldedFg guifg=Normal.foreground
" hi default UfoFoldedBg guibg=Folded.background
hi default link UfoPreviewSbar PmenuSbar
hi default link UfoPreviewThumb PmenuThumb
hi default link UfoPreviewWinBar UfoFoldedBg
hi default link UfoPreviewCursorLine Visual
hi default link UfoFoldedEllipsis Comment
hi default link UfoCursorFoldedLine CursorLine
hi Folded guibg=NONE
" }}}

" Plugin: vim-signature {{{
hi SignatureMarkText guifg=#756207 guibg=NONE
hi SignatureMarkerText guifg=#4EA9D7 guibg=NONE
" }}}

" Plugin: focus.nvim {{{
hi link UnfocusedWindow CursorLine
hi link FocusedWindow NONE
" }}}

if g:colors_name == "custom_hybrid_reverse"
  " Highlights: General GUI {{{
  " Ref: https://github.com/mhinz/vim-janah
  hi Comment guibg=NONE ctermbg=NONE cterm=italic gui=italic
  " Transparent bg
  hi clear Conceal

  " " OLD
  " hi DiffAdd ctermbg=235 ctermfg=108 cterm=reverse guibg=#262626 guifg=#87af87 gui=reverse
  " hi DiffChange ctermbg=235 ctermfg=103 cterm=reverse guibg=#262626 guifg=#8787af gui=reverse
  " hi DiffDelete ctermbg=235 ctermfg=131 cterm=reverse guibg=#262626 guifg=#af5f5f gui=reverse
  " hi DiffText ctermbg=235 ctermfg=208 cterm=reverse guibg=#262626 guifg=#ecec93 gui=reverse

  " Diff
  hi DiffAdd guibg=#1d3024 guifg=NONE
  hi DiffChange guibg=#302f1d guifg=NONE
  hi DiffDelete guibg=NONE guifg=#585858
  hi DiffText guibg=#322029 guifg=NONE
  " }}}

  " Plugin: gitsigns {{{
  hi GitSignsAdd ctermfg=22 guifg=#008500 ctermbg=234 guibg=NONE
  hi GitSignsChange ctermfg=58 guifg=#808200 ctermbg=234 guibg=NONE
  hi GitSignsDelete ctermfg=52 guifg=#800000 ctermbg=234 guibg=NONE
  hi GitSignsChangeDelete ctermfg=52 guifg=#800000 ctermbg=234 guibg=NONE
  " }}}

  " Plugin: vim-signature {{{
  hi SignatureMarkText    ctermfg=11 guifg=#756207 ctermbg=234 guibg=#1c1c1c
  hi SignatureMarkerText  ctermfg=12 guifg=#4EA9D7 ctermbg=234 guibg=#1c1c1c
  " }}}

  " Plugin: dashboard {{{
  hi DashboardHeader guifg=#FFD700 guibg=NONE
  hi DashboardCenter guifg=#D7D7BC guibg=NONE
  hi DashboardShortcut guifg=#D7D17C guibg=NONE
  hi DashboardFooter guifg=#767676 guibg=NONE
  " }}}

  " Plugin: nvim-cmp {{{
  hi CmpItemKindCopilot guifg=#6CC644
  hi CmpItemKindTabnine guifg=#CA42F0
  hi CmpItemKindEmoji guifg=#FDE030
  " }}}

  " Plugin: neogit {{{
  hi NeogitNotificationInfo guifg=#80ff95
  hi NeogitNotificationWarning guifg=#fff454
  hi NeogitNotificationError guifg=#c44323
  " }}}

  " Plugin: focus.nvim {{{
  hi link UnfocusedWindow TabLine
  hi link FocusedWindow VisualNOS
  " }}}
endif

" Leading Whitespace Highlight {{{
" Ref: https://vim.fandom.com/wiki/Highlight_unwanted_spaces
highlight ExtraWhitespace guifg=#30302c guibg=#30302c ctermfg=236 ctermbg=236
augroup WhitespaceMatch
  " Remove ALL autocommands for the WhitespaceMatch group.
  autocmd!
  autocmd BufWinEnter * let w:whitespace_match_number =
        \ matchadd('ExtraWhitespace', '\s\+$')
  autocmd InsertEnter * call s:ToggleWhitespaceMatch('i')
  autocmd InsertLeave * call s:ToggleWhitespaceMatch('n')
augroup END
function! s:ToggleWhitespaceMatch(mode)
  let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
  if exists('w:whitespace_match_number')
    call matchdelete(w:whitespace_match_number)
    call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
  else
    " Something went wrong, try to be graceful.
    let w:whitespace_match_number =  matchadd('ExtraWhitespace', pattern)
  endif
endfunction
" }}}

" DEPRECATED: Detect color syntax group under cursor
nnoremap <F10> :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name")
    \ . '> trans<' . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
