let g:taskwiki_markup_syntax = 'markdown'
let g:taskwiki_dont_preserve_folds = 'yes'
let g:taskwiki_disable_concealcursor = 'yes'
let g:taskwiki_suppress_mappings = 'yes'

augroup VimwikiTodoListDetect
  autocmd!
  autocmd Filetype vimwiki call TodoListDetectEnable()
augroup END

" Enable autocmds if file contains 'title:TODO list' metadata or '# Todo List'
" markdown header in the first 10 lines of the file
function! TodoListDetectEnable() abort
  let n = 1
  if expand('%:t:r') =~ '^\v\d{4}-\d\d-\d\d'
    augroup TaskWikiSync
      autocmd! BufEnter,FocusGained <buffer> TaskWikiBufferLoad
    augroup END
    augroup TaskWarriorSync
      autocmd! BufWritePost <buffer> call TaskWarriorServerUpdate('task sync', v:false)
      " The line '[Process exited ?]' is appended to the terminal buffer after the
      " `TermClose` event. So we use a timer to wait a few milliseconds to read the
      " exit status. Setting the timer to 1 or 1 ms is not sufficient; 20 ms seems
      " to work fine.
      autocmd! TermClose * call timer_start(20, { -> s:afterTermClose() })
    augroup END
  endif
endfunction

function! TaskWarriorServerUpdate(command, force) abort
  " Sync only if has changes and no terminal is open running the command
  if getbufvar(bufnr('%'), '&modified') == 0 && a:force != v:true && !s:TaskDirty()
    silent execute 'up'
    return
  endif

  " Close instance of terminal if exist
  let term_bufNr = s:jumpToTermJob(a:command)
  if term_bufNr != 0 && has('nvim')
    if jobwait([getbufvar(term_bufNr, '&channel')], 0)[0] == -1
      return
    else
      silent execute 'bw! ' . term_bufNr
    endif
  endif

  if a:force == v:true || s:TaskDirty()
    silent exe "split | resize 4 | term " . "echo \"Executing '" . a:command . "'...\" && " . a:command
    execute bufwinnr(s:jumpToTermJob(a:command)) . 'wincmd w | normal! G'
  endif
endfunction

" Jump to the earliest terminal window if exists
" return buffer number, else 0
function! s:jumpToTerm() abort
  for bufNr in range(1, bufnr('$'))
    if getbufvar(bufNr, '&buftype') == 'terminal'
      execute bufwinnr(bufNr) . 'wincmd w'
      return bufNr
    endif
  endfor
  return 0
endfunction

" Jump to the terminal running the given command or earliest terminal window if exists
" return buffer number, else 0
function! s:jumpToTermJob(command) abort
  if has('nvim')
    for bufNr in range(1, bufnr('$'))
      if getbufvar(bufNr, 'term_title') =~ a:command
        execute bufwinnr(bufNr) . 'wincmd w'
        return bufNr
      endif
    endfor
  else
    for bufNr in range(1, bufnr('$'))
      if getbufvar(bufNr, '&buftype') == 'terminal'
        execute bufwinnr(bufNr) . 'wincmd w'
        return bufNr
      endif
    endfor
  endif
  return 0
endfunction

function s:TaskDirty() abort
  return system("task | grep 'Sync required'") =~ 'Sync required'
        \ && !filereadable("/tmp/task_sync.lock")
endfunction

" Get the exit status from a terminal buffer by looking for a line near the end
" of the buffer with the format, '[Process exited ?]'.
" Ref: https://vi.stackexchange.com/a/17388
function! s:getExitStatus() abort
  let ln = line('$')
  " The terminal buffer includes several empty lines after the 'Process exited'
  " line that need to be skipped over.
  while ln >= 1
    let l = getline(ln)
    let ln -= 1
    let exitCode = substitute(l, '^\[Process exited \([0-9]\+\)\]$', '\1', '')
    if l != '' && l == exitCode
      " The pattern did not match, and the line was not empty. It looks like
      " there is no process exit message in this buffer.
      break
    elseif exitCode != ''
      return str2nr(exitCode)
    endif
  endwhile
  throw 'Could not determine exit status for buffer, ' . expand('%')
endfunc

function! s:afterTermClose() abort
  while s:jumpToTerm() != 0
    if s:getExitStatus() == 0
      bdelete!
    endif
  endwhile
  silent exe "TaskWikiBufferLoad"
endfunc

