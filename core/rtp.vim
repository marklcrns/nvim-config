" Set main configuration directory as parent directory
let $VIM_PATH = fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
" Set data/cache directory as $XDG_CACHE_HOME/vim
let $DATA_PATH = expand(($XDG_CACHE_HOME ? $XDG_CACHE_HOME : '~/.cache') . '/vim')
" Set sync directory
let $SYNC_PATH = expand($HOME . '/Sync/cache/vim')

" When using VIMINIT trick for exotic MYVIMRC locations, add path now.
if &runtimepath !~# $VIM_PATH
  set runtimepath^=$VIM_PATH
  set runtimepath+=$VIM_PATH/after
endif

" Ensure data directories
for s:path in [
      \ $DATA_PATH,
      \ $SYNC_PATH,
      \ $DATA_PATH . '/undo',
      \ $DATA_PATH . '/backup',
      \ $DATA_PATH . '/session',
      \ $SYNC_PATH . '/session',
      \ $VIM_PATH . '/spell'
      \ ]
  if ! isdirectory(s:path)
    call mkdir(s:path, 'p', 0770)
  endif
endfor


