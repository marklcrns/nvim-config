" Set main configuration directory as parent directory
let $VIM_PATH = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
" Set secondary nvim configuration directory
let $LOCAL_VIM_PATH = expand($HOME.'/.local-nvim.d')
" Set data/cache directory as $XDG_CACHE_HOME/vim
let $DATA_PATH = expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache') . '/vim')
" Set the secondary user init config file
let g:user_init_config = expand($LOCAL_VIM_PATH . '/init.vim')

" When using VIMINIT trick for exotic MYVIMRC locations, add path now.
if &runtimepath !~# $VIM_PATH
  set runtimepath^=$VIM_PATH
  set runtimepath+=$VIM_PATH/after
endif

if &runtimepath !~# $LOCAL_VIM_PATH
  set runtimepath^=$LOCAL_VIM_PATH
  set runtimepath+=$LOCAL_VIM_PATH/after
endif

" Ensure data directories
for s:path in [
      \ $DATA_PATH,
      \ $DATA_PATH . '/undo',
      \ $DATA_PATH . '/backup',
      \ $DATA_PATH . '/session',
      \ $VIM_PATH . '/spell' ]
  if ! isdirectory(s:path)
    call mkdir(s:path, 'p', 0770)
  endif
endfor


