function! AdjustFontSize(amount)
  let g:guifontsize = g:guifontsize+a:amount
  exec "GuiFont! " . g:guifont . ":h" . g:guifontsize
endfunction

noremap <silent> <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
noremap <silent> <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
inoremap <silent> <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
inoremap <silent> <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a

call AdjustFontSize(g:guifontsize)
