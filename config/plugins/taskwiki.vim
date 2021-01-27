let g:taskwiki_markup_syntax = 'markdown'
let g:taskwiki_dont_preserve_folds = 'yes'
let g:taskwiki_disable_concealcursor = 'yes'
let g:taskwiki_suppress_mappings = 'yes'

function! TaskWikiUpdate()
  silent !task sync
  exe "TaskWikiBufferLoad"
  echom strftime("%Y-%m-%d %H:%M:%S") . ": Task synced and loaded!"
endfunction

augroup TaskWikiReload
  autocmd! Filetype vimwiki
    \ autocmd! FocusGained <buffer> call TaskWikiUpdate()
augroup END

nnoremap <LocalLeader>tu :call TaskWikiUpdate()<CR>
