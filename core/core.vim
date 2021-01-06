if &compatible
  " vint: -ProhibitSetNoCompatible
  set nocompatible
  " vint: +ProhibitSetNoCompatible
endif

" Set main configuration directory as parent directory
let $VIM_PATH = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
" Set secondary nvim configuration directory
let $CUSTOM_VIM_PATH = expand($HOME.'/.nvim-user.d')

" Set python interpreter from a dedicated virtual environment
let s:python = expand($VIM_PATH.'/env/python/env/bin/python')
let s:python3 = expand($VIM_PATH.'/env/python3/env/bin/python3')

if !empty(glob(s:python)) && !isdirectory(s:python)
  let g:python_host_prog = s:python
endif
if !empty(glob(s:python3)) && !isdirectory(s:python3)
  let g:python3_host_prog = s:python3
endif

" Set the secondary user config file
let s:user_init_config = expand($CUSTOM_VIM_PATH.'/init.vim')

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

let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

" Set global variables
let g:activate_cursorline = 1
let g:activate_cursorcolumn = 0

" Initialize base requirements
if has('vim_starting')
  " Set leader and localleader keys
  let g:mapleader="\<Space>"
  let g:maplocalleader=';'

  " Release keymappings prefixes, evict entirely for use of plug-ins.
  nnoremap <Space>  <Nop>
  xnoremap <Space>  <Nop>
  nnoremap ,        <Nop>
  xnoremap ,        <Nop>
  nnoremap ;        <Nop>
  xnoremap ;        <Nop>

endif

" Initialize plugin-manager and load plugins config files
call utils#source_file($VIM_PATH,'core/package_manager.vim')
call utils#source_file($VIM_PATH,'config/keybinds.vim')

call utils#source_file($VIM_PATH,'core/general.vim')
call utils#source_file($VIM_PATH,'core/filetype.vim')
call utils#source_file($VIM_PATH,'core/mappings.vim')

" Load user init config
call utils#check_source(s:user_init_config)

if get(g:, 'statusline_plugin_enable', 1)
  call utils#source_file($VIM_PATH,'core/statusline.vim')
endif
if get(g:, 'tabline_plugin_enable', 1)
  call utils#source_file($VIM_PATH,'core/tabline.vim')
endif

call theme#init()

set secure

