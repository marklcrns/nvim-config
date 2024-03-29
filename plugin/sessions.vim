" Session Management
" ---
"
" Behaviors:
" - Save active session when quitting vim completely
"
" Commands:
" - SeshSave [name]    Create and activate new session
" - SeshLoad [name]    Clear buffers and load selected session
" - SeshDelete [name]  Clear buffers and load selected session
" - SeshClose:         Save session and clear all buffers
" - SeshDetach:        Stop persisting session, leave buffers open
" - SeshList:          List all existing session in session directory
"
" If [name] is empty, the current working-directory is used.
"
" Options:
" - g:session_directory defaults to DATA_PATH/session (see config/vimrc)

if exists('g:loaded_sessionsplugin')
  finish
endif
let g:loaded_sessionsplugin = 1

" Options
" ---

let g:session_directory = get(g:, 'session_directory', $DATA_PATH . '/session')

" Commands
" ---

" Save and persist session
command! -nargs=? -complete=customlist,<SID>session_list SeshSave
      \ call s:session_save(<q-args>)

" Load and persist session
command! -nargs=? -complete=customlist,<SID>session_list SeshLoad
      \ call s:session_load(<q-args>)

" Load and persist session
command! -nargs=? -complete=customlist,<SID>session_list SeshDelete
      \ call s:session_delete(<q-args>)

" Close session, but leave buffers opened
command! SeshDetach call s:session_detach()

" Close session and all buffers
command! SeshClose call s:session_close()

" List all sessions
command! SeshList execute('!stat -c "\%y \%n" ' . g:session_directory . '/*.vim')

" Save session on quit if one is loaded
augroup plugin_sessions
  autocmd!

  " If session is loaded, write session file on quit
  autocmd VimLeavePre * call s:session_save_current()

  " autocmd SeshLoadPost * ++once unsilent
  " \ echomsg 'Loaded "' . fnamemodify(v:this_session, ':t:r') . '" session'
augroup END

" Private functions
" ---

function! s:session_save(name)
  if ! isdirectory(g:session_directory)
    call mkdir(g:session_directory, 'p')
  endif
  let file_name = empty(a:name) ? s:project_name() : a:name
  let file_path = g:session_directory . '/' . file_name . '.vim'
  execute 'mksession! ' . fnameescape(file_path)
  let v:this_session = file_path

  echohl MoreMsg
  echo 'Session `' . file_name . '` is now persistent.'
  echohl None
endfunction

function! s:session_load(name)
  call s:session_save_current()

  let file_name = empty(a:name) ? s:project_name() : a:name
  let file_path = g:session_directory . '/' . file_name . '.vim'
  if filereadable(file_path)
    call s:buffers_wipeout()
    execute 'silent source ' . file_path
  else
    echohl ErrorMsg
    echomsg 'The session "' . file_path . '" doesn''t exist.'
    echohl None
  endif
endfunction

function! s:session_delete(name)
  let file_name = empty(a:name) ? s:project_name() : a:name
  let file_path = g:session_directory . '/' . file_name . '.vim'

  if v:this_session == file_path
    call s:session_detach()
  endif

  if filereadable(file_path)
    if delete(file_path) == -1
      echohl ErrorMsg
      echomsg 'The session "' . file_path . '" deletion failed!'
      echohl None
    else
      echomsg 'The session "' . file_path . '" is deleted.'
    endif
  else
    echohl ErrorMsg
    echomsg 'The session "' . file_path . '" doesn''t exist.'
    echohl None
  endif
endfunction

function! s:session_close()
  if ! empty(v:this_session) && ! exists('g:SeshLoad')
    call s:session_save_current()
    call s:session_detach()
    call s:buffers_wipeout()
  endif
endfunction

function! s:session_save_current()
  if ! empty(v:this_session) && ! exists('g:SeshLoad')
    execute 'mksession! ' . fnameescape(v:this_session)
  endif
endfunction

function! s:session_detach()
  if ! empty(v:this_session) && ! exists('g:SeshLoad')
    let v:this_session = ''
    redrawtabline
    redrawstatus
  endif
endfunction

function! s:buffers_wipeout()
  noautocmd silent! %bwipeout!
endfunction

function! s:session_list(A, C, P)
  let glob_pattern = g:session_directory . '/' . fnameescape(a:A) . '*.vim'
  return map(split(glob(glob_pattern), '\n'), "fnamemodify(v:val, ':t:r')")
endfunction

function! s:project_name()
  let l:cwd = resolve(getcwd())
  let l:cwd = substitute(l:cwd, '^' . $HOME . '/', '', '')
  let l:cwd = fnamemodify(l:cwd, ':p:gs?/?_?')
  let l:cwd = substitute(l:cwd, '^\.', '', '')
  return l:cwd
endfunction

