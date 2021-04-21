let g:taskwiki_markup_syntax = 'markdown'
let g:taskwiki_dont_preserve_folds = 'yes'
let g:taskwiki_disable_concealcursor = 'yes'
let g:taskwiki_suppress_mappings = 'yes'

function! TaskWikiUpdate()
  silent exe "TaskWikiBufferLoad"
endfunction

function! TaskWarriorServerUpdate()
  silent exe "!trellowarrior sync &; task sync &"
endfunction

augroup TaskWikiSync
  autocmd!
  autocmd! Filetype vimwiki
    \ autocmd! FocusGained <buffer> call TaskWikiUpdate()
augroup END

augroup TaskWarriorSync
  autocmd! Filetype vimwiki
    \ autocmd! BufWritePost <buffer> call TaskWarriorServerUpdate()
augroup END

nnoremap <LocalLeader>tu :call TaskWikiUpdate()<CR>
nnoremap <LocalLeader>tU :call TaskWarriorServerUpdate()<CR>
