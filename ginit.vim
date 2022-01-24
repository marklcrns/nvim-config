let s:guifontsize = 14
let s:guifont = 'Source\ Code\ Pro\ iCursive\ S12'


function! AdjustFontSize(amount)
  let s:guifontsize = s:guifontsize+a:amount
  exec "GuiFont! " . s:guifont . ":h" . s:guifontsize
endfunction

noremap <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
noremap <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
inoremap <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a

call AdjustFontSize(s:guifontsize)
