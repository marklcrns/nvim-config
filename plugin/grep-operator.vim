" Custom script to grep visual or motion selected text recursively
" Ref: https://learnvimscriptthehardway.stevelosh.com/chapters/34.html

nnoremap <leader>G :set operatorfunc=<SID>GrepOperator<cr>g@
vnoremap <leader>G :<c-u>call <SID>GrepOperator(visualmode())<cr>

function! s:GrepOperator(type)
  let unnamed_register_save = @@
  " Only supports visual characterwise and normal characterwise motion
  if a:type ==# 'v'
    normal! `<v`>y
  elseif a:type ==# 'char'
    normal! `[y`]
  else
    return
  endif
  " Only use default external grep and Ripgrep
  if stridx(expand(&grepprg), "grep") ==# 0
    echom "Using default external grep"
    silent execute "grep! -R " . shellescape(@@) . " **/*"
    copen
  elseif stridx(expand(&grepprg), "rg") ==# 0
    echom "Using ripgrep"
    silent execute "grep! " . shellescape(@@) . " **/*"
    copen
  else
    echohl WarningMsg | echo '&grepprg not supported' | echohl None
    return
  endif
  " restory default yank/delete register
  let @@ = unnamed_register_save
endfunction

