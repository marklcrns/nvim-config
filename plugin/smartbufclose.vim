" File: smartbufclose.vim
"
" Author:
"   Mark Lucernas
"   https://github.com/marklcrns
"
" Description:
"   Sensibly delete current buffer with respect to alternate tabs and window
"   splits.
"
" Features:
"   - Delete buffers with preserving tabs and window splits displaying the same
"     buffer to be deleted.
"   - Keep tabs and window splits open with an empty buffer if pointing to
"     same buffer to be deleted.
"   - Auto delete empty buffers (will close tabs and window splits).
"   - Prevents from deleting buffer if modified.
"
" Usage:
"   :SmartBufClose
"
" Credits:
"   - CleanEmptyBuffers()
"     https://stackoverflow.com/a/10102604
"   - SmartBufClose()
"     https://github.com/cespare/vim-sbd
"     https://stackoverflow.com/a/29236158
"     https://superuser.com/questions/345520/vim-number-of-total-buffers
"




" List of excluded filetypes to preserve windows when clearing splits
" see CloseAllModifiableWin()
let g:smartbufclose_excluded_filetypes = [
      \ 'vista', 'fern', 'Mundo', 'MundoDiff', 'minimap', 'fugitive',
      \ 'gitcommit' ]



function! s:CleanEmptyBuffers()
  let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0 && !getbufvar(v:val, "&mod")')
  if !empty(buffers)
    " Wipe all empty buffers
    execute 'bw ' . join(buffers, ' ')
  endif
endfunction

function! s:ShiftAllWindowsBufferPointingToBuffer(buffer)
  " Loop through tabs
  for i in range(1, tabpagenr('$'))
    " Go to tab
    execute 'tabnext ' . i

    if winnr('$') ># 1
      " Store active window nr to restore later
      let curWin = winnr()

      " Loop through windows pointing to curBuf
      let winnr = bufwinnr(a:buffer)
      while (winnr >= 0)
        " Go to window and switch to next buffer
        execute winnr . 'wincmd w | bnext'
        " Restore active window
        execute curWin . 'wincmd w'
        let winnr = bufwinnr(a:buffer)
      endwhile
    endif
  endfor
endfunction

" Close all splits excluding given filetype list
function! s:CloseAllModifiableWin(excluded_filetypes)
  let splitsClosed = 0
  " Close window splits if > 1
  if winnr('$') ># 1
    let excludedFiletypes = join(a:excluded_filetypes, '\|')
    " Store active window nr to restore later
    let curWin = winnr()
    " Loop over window splits
    for _ in range(1, winnr('$'))
      " Go to next window
      silent execute "wincmd w"
      " Close window splits if not in filetype exclusions, is modifiable, or empty
      if (&ft !~ excludedFiletypes || &modifiable) && &ft !=# ''
        execute "silent! close"
        let splitsClosed += 1
      endif
    endfor
    " Restore active window
    execute curWin . 'wincmd w'
    echo "splits closed " . splitsClosed
  endif

  " Return total window splits closed
  return splitsClosed
endfunction

function! <SID>SmartBufClose()
  let curBuf = bufnr('%')
  let curBufName = bufname('%')
  let curTab = tabpagenr()

  call s:CleanEmptyBuffers()
  " Store listed buffers count
  let curBufCount = len(getbufinfo({'buflisted':1}))

  " Immediately quit/wipe certain buffers
  if &filetype ==# 'gitcommit'
    silent execute 'q!'
    return
  elseif !&modifiable
    silent execute 'bw!'
    return
  elseif ((curBufCount ==# 1 && curBufName ==# '') || &buftype ==# 'nofile') " Quit when only buffer and empty
    " Close all splits if exists, else quit vim
    if s:CloseAllModifiableWin(g:smartbufclose_excluded_filetypes) ==# 0
      silent execute 'qa!'
      return
    endif
  elseif (curBufName ==# '' || &readonly || &buftype ==# 'terminal') " Wipe readonly buffer, terminal, and empty to remove from jump stack
    silent execute 'bw!'
    return
  endif

  " Create empty buffer if only buffer w/o window splits, else close split
  if getbufvar(curBuf, '&modified') == 1
    echohl WarningMsg | echo "Changes detected. Please save your file!" | echohl None
  else
    if curBufCount ># 1
        " Prevent tabs and windows from closing if pointing to the same curBuf
        " by switching to next buffer before deleting curBuf
        call s:ShiftAllWindowsBufferPointingToBuffer(curBuf)

        " Close buffer and restore active tab
        silent execute 'silent! bdelete' . curBuf
        silent execute 'silent! tabnext ' . curTab
    else
      " Create new buffer empty if no splits and delete curBuf
      execute 'enew'
      call s:ShiftAllWindowsBufferPointingToBuffer(curBuf)
      execute "silent! " . curBuf . "bdelete"
    endif
  endif
endfunction



command! -nargs=0 SmartBufClose call <SID>SmartBufClose()

