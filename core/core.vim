if &compatible
  " vint: -ProhibitSetNoCompatible
  set nocompatible
  " vint: +ProhibitSetNoCompatible
endif

" Disable vim distribution plugins
let g:loaded_gzip = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1

let g:loaded_getscript = 1
let g:loaded_getscriptPlugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1

let g:loaded_matchit = 1
let g:loaded_matchparen = 1
let g:loaded_2html_plugin = 1
let g:loaded_logiPat = 1
let g:loaded_rrhelper = 1

" Needed by vim-fugitive :GBrowse
" let g:loaded_netrw = 1
" let g:loaded_netrwPlugin = 1
" let g:loaded_netrwSettings = 1
" let g:loaded_netrwFileHandlers = 1

" Initialize start up base requirements
if has('vim_starting')
  " Python interpreter settings
  if has('nvim')
    " Set python interpreter from a dedicated virtualenv created by generate_venv.sh
    let python = $DATA_PATH . '/venv/python/env/bin/python'
    let python3 = $DATA_PATH . '/venv/python3/env/bin/python3'
    if filereadable(python)
      let g:python_host_prog = python
    endif
    if filereadable(python3)
      let g:python3_host_prog = python3
    endif
  elseif has('pythonx')
    if has('python3')
      set pyxversion=3
    elseif has('python')
      set pyxversion=2
    endif
  endif

  " Enables 24-bit RGB color in the terminal
  if has('termguicolors')
    if empty($COLORTERM) || $COLORTERM =~# 'truecolor\|24bit'
      set termguicolors
    endif
  endif

  if ! has('nvim')
    set t_Co=256
    " Set Vim-specific sequences for RGB colors
    " Fixes 'termguicolors' usage in vim+tmux
    " :h xterm-true-color
    let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
    let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  endif

  " Vim only, Linux terminal settings
  if ! has('nvim') && ! has('gui_running') && ! has('win32') && ! has('win64')
    call utils#source_file($VIM_PATH, 'core/terminal.vim')
  endif
endif

call utils#source_file($VIM_PATH, 'core/general.vim')
" call utils#source_file($VIM_PATH, 'core/filetype.vim')
call utils#source_file($VIM_PATH, 'core/mappings.vim')

set secure
