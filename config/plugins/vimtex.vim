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
let g:matchup_override_vimtex = 1
let g:matchup_matchparen_deferred = 1
let g:vimtex_quickfix_mode = 0

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
