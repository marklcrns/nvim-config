let g:taskwiki_markup_syntax = 'markdown'
let g:taskwiki_dont_preserve_folds = 'yes'
let g:taskwiki_disable_concealcursor = 'yes'
let g:taskwiki_suppress_mappings = 'yes'

function! TaskWikiUpdate()
  silent exe "TaskWikiBufferLoad"
endfunction

function! TaskWarriorServerUpdate()
  let l:command = 'trellowarrior sync; task sync'
  " Sync only if has changes and no terminal is open running/ran the command
  if &modified == 0
    return
  endif
  if has('nvim')
    for bufferNum in range(1, bufnr('$'))
      if getbufvar(bufferNum, 'term_title') =~ l:command
        return
      endif
    endfor
  else
    for bufferNum in range(1, bufnr('$'))
      if getbufvar(bufferNum, '&buftype') == 'terminal'
        return
      endif
    endfor
  endif
  silent exe "w!"
  silent exe "split | resize 5 | term " . l:command
endfunction

augroup TaskWikiSync
  autocmd!
  autocmd! Filetype vimwiki
    \ autocmd! FocusGained <buffer> call TaskWikiUpdate()
augroup END

augroup TaskWarriorSync
  autocmd! Filetype vimwiki
    \ autocmd! BufWriteCmd <buffer> call TaskWarriorServerUpdate()
augroup END

nnoremap <LocalLeader>tu :call TaskWikiUpdate()<CR>
nnoremap <LocalLeader>tU :call TaskWarriorServerUpdate()<CR>
