" Requires latexmk installation Debian:
" sudo apt install -y latexmk
"
" Additionally, to compile Xelatex, install texlive-xetex and add this line at
" the top of .tex files:
"
" "%! TeX program = xelatex
"
" Ref: https://tex.stackexchange.com/questions/392198/vimtex-and-xelatex

let g:tex_flavor = 'latex'
let g:vimtex_view_method = 'zathura'
let g:vimtex_mappings_enabled = 1
let g:vimtex_fold_enabled = 0
let g:vimtex_fold_manual = 1
let g:vimtex_complete_enabled = 0
" let g:matchup_override_vimtex = 1
" let g:matchup_matchparen_deferred = 1

set conceallevel=1
let g:tex_conceal='abdmg'

let g:vimtex_compiler_latexmk = {
      \ 'build_dir' : 'build',
      \ 'callback' : 1,
      \ 'continuous' : 1,
      \ 'executable' : 'latexmk',
      \ 'hooks' : [],
      \ 'options' : [
      \   '-verbose',
      \   '-file-line-error',
      \   '-synctex=1',
      \   '-interaction=nonstopmode',
      \ ],
      \}

let g:vimtex_quickfix_ignore_filters = [
      \ 'LaTeX Font Warning',
      \ ]

augroup LaTeXEditMode
  autocmd!
  " Toggle conceallevel on and off Insert mode
  autocmd FileType tex,plaintex,latex
        \ autocmd InsertEnter <buffer> setlocal conceallevel=0
  autocmd FileType tex,plaintex,latex
        \ autocmd InsertLeave <buffer> setlocal conceallevel=2

  " Toggles conceallevel on and off Visual Mode
  autocmd FileType tex,plaintex,latex
        \ autocmd ModeChanged [vV\x16]*:* let &l:cole = 2
  autocmd FileType tex,plaintex,latex
        \ autocmd ModeChanged *:[vV\x16]* let &l:cole = 0
augroup END

