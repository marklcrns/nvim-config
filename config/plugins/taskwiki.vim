let g:taskwiki_markup_syntax = 'markdown'
let g:taskwiki_dont_preserve_folds = 'yes'
let g:taskwiki_disable_concealcursor = 'yes'
let g:taskwiki_suppress_mappings = 'yes'

augroup VimwikiTodoListDetect
  autocmd!
  autocmd! Filetype vimwiki call TodoListDetectEnable()
augroup END

" Enable autocmds if file contains 'title:TODO list' metadata or '# Todo List'
" markdown header in the first 10 lines of the file
function! TodoListDetectEnable()
  let n = 1
  while n < 10 && n < line("$")
    if getline(n) =~ 'title: TODO list\|# Todo List'
      augroup TaskWikiSync
        autocmd!
        autocmd! FocusGained <buffer> call TaskWikiUpdate()
      augroup END
      augroup TaskWarriorSync
        autocmd!
        autocmd! BufWriteCmd <buffer> call TaskWarriorServerUpdate(0, 'trellowarrior sync; task sync')
      augroup END
      return
    endif
    let n = n + 1
  endwhile
endfunction

function! TaskWikiUpdate()
  silent exe "TaskWikiBufferLoad"
endfunction

function! TaskWarriorServerUpdate(force, command)
  " Sync only if has changes and no terminal is open running the command
  let @x = system("task | grep 'Sync required'")
  if &modified == 0 && a:force != 1 && !(@x =~ 'Sync required')
    return
  endif
  let g:has_taskwiki_changes = 1

  " Close instance of terminal if exist
  if has('nvim')
    for bufferNum in range(1, bufnr('$'))
      " Look for terminal running the command
      if getbufvar(bufferNum, 'term_title') =~ a:command
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

  if g:has_taskwiki_changes == 1 || a:force == 1
    echo "Syncing task server"
    silent exe "w! | TaskWikiBufferSave"
    let g:has_taskwiki_changes = v:false
    silent exe "split | resize 5 | term " . "echo \"Executing '" . a:command . "'...\" && " . a:command
  endif
endfunction

