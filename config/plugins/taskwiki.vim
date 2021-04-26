let g:taskwiki_markup_syntax = 'markdown'
let g:taskwiki_dont_preserve_folds = 'yes'
let g:taskwiki_disable_concealcursor = 'yes'
let g:taskwiki_suppress_mappings = 'yes'

function! TaskWikiUpdate()
  silent exe "TaskWikiBufferLoad"
endfunction

function! TaskWarriorServerUpdate()
  let l:command = 'trellowarrior sync; task sync'
  " Sync only if has changes and no terminal is open running the command
  if &modified == 0
    return
  else
    let g:has_taskwiki_changes = 1
  endif
  if has('nvim')
    for bufferNum in range(1, bufnr('$'))
      " Look for terminal running the command
      if getbufvar(bufferNum, 'term_title') =~ l:command
        " if still running, return, else wipe terminal buffer
        if jobwait([getbufvar(bufferNum, '&channel')], 0)[0] == -1
          return
        else
          silent execute 'bw! ' . bufferNum
        endif
      endif
    endfor
  else
    for bufferNum in range(1, bufnr('$'))
      if getbufvar(bufferNum, '&buftype') == 'terminal'
        return
      endif
    endfor
  endif
  if g:has_taskwiki_changes
    silent exe "w! | TaskWikiBufferSave"
    silent exe "split | resize 5 | term " . l:command
    let g:has_taskwiki_changes = 0
  endif
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
