return function()
  vim.cmd([[
    let g:vim_you_autocorrect=v:false
    let g:vim_you_autocorrect_autotoggle=v:true

    function! s:enable_autocorrect() abort
      exec "EnableAutocorrect"
      let g:vim_you_autocorrect=v:true
      imap <silent><buffer> <C-s> <C-O><Plug>VimyouautocorrectUndo
    endfunction

    function! s:disable_autocorrect() abort
      exec "DisableAutocorrect"
      let g:vim_you_autocorrect=v:false
      inoremap <buffer> <C-s> <Esc>:set spell<bar>norm i<C-g>u<Esc>[s"syiW1z="tyiW:let @l=line('.')<bar>let @c=virtcol('.')<CR>``a<C-g>u<Esc>:echo getreg('l') . ":" . getreg('c') . " spell fixed (" . getreg('s') . " -> " . getreg('t') . ")"<CR>la
    endfunction

    function! ToggleAutoCorrect() abort
      if get(g:, 'vim_you_autocorrect_autotoggle', v:false)
        call s:disable_autocorrect()
        let g:vim_you_autocorrect_autotoggle=v:false
        echo "Autocorrect Disabled"
      else
        call s:enable_autocorrect()
        let g:vim_you_autocorrect_autotoggle=v:true
        echo "Autocorrect Enabled"
      endif
    endfunction

    augroup ILoveCorrections
      autocmd!
      autocmd BufEnter *
            \ if (&ft ==# 'markdown' || &ft ==# 'vimwiki' || &ft ==# 'norg') && get(g:, 'loaded_vim_you_autocorrect', 0) && get(g:, 'vim_you_autocorrect_autotoggle', v:false)
            \| call s:enable_autocorrect()
            \| endif
      autocmd BufLeave *
            \ if (&ft ==# 'markdown' || &ft ==# 'vimwiki' || &ft ==# 'norg') && get(g:, 'loaded_vim_you_autocorrect', 0) && get(g:, 'vim_you_autocorrect_autotoggle', v:false)
            \| call s:disable_autocorrect()
            \| endif
    augroup END

    highlight AutocorrectGood ctermfg=Yellow guifg=Yellow gui=undercurl

    " function! ToggleAutoCorrect() abort
    "   if get(g:, 'vim_you_autocorrect_autotoggle', v:false)
    "     exec "DisableAutocorrect"
    "     let g:vim_you_autocorrect=v:false
    "     let g:vim_you_autocorrect_autotoggle=v:false
    "     inoremap <buffer> <C-s> <Esc>:set spell<bar>norm i<C-g>u<Esc>[s"syiW1z="tyiW:let @l=line('.')<bar>let @c=virtcol('.')<CR>``a<C-g>u<Esc>:echo getreg('l') . ":" . getreg('c') . " spell fixed (" . getreg('s') . " -> " . getreg('t') . ")"<CR>la
    "     nnoremap <silent><buffer> z= z=
    "     echo "Autocorrect Disabled"
    "   else
    "     exec "EnableAutocorrect"
    "     let g:vim_you_autocorrect=v:true
    "     let g:vim_you_autocorrect_autotoggle=v:true
    "     imap <silent><buffer> <C-s> <C-O><Plug>VimyouautocorrectUndo
    "     nmap <silent><buffer> z= <Plug>VimyouautocorrectJump<Plug>VimyouautocorrectUndo:call feedkeys('z=', 'n')<CR>
    "     echo "Autocorrect Enabled"
    "   endif
    " endfunction
    "
    " augroup ILoveCorrections
    "   autocmd!
    "   autocmd BufEnter *
    "         \ if (&ft ==# 'markdown' || &ft ==# 'vimwiki' || &ft ==# 'norg') && get(g:, 'loaded_vim_you_autocorrect', 0) && get(g:, 'vim_you_autocorrect_autotoggle', v:false)
    "           \| exec "EnableAutocorrect"
    "           \| let g:vim_you_autocorrect=v:true
    "           \| imap <silent><buffer> <C-s> <C-O><Plug>VimyouautocorrectUndo
    "           \| nmap <silent><buffer> z= <Plug>VimyouautocorrectJump<Plug>VimyouautocorrectUndo:call feedkeys('z=', 'n')<CR>
    "         \| endif
    "   autocmd BufLeave *
    "         \ if (&ft ==# 'markdown' || &ft ==# 'vimwiki' || &ft ==# 'norg') && get(g:, 'loaded_vim_you_autocorrect', 0) && get(g:, 'vim_you_autocorrect_autotoggle', v:false)
    "           \| exec "DisableAutocorrect"
    "           \| let g:vim_you_autocorrect=v:false
    "           \| inoremap <buffer> <C-s> <Esc>:set spell<bar>norm i<C-g>u<Esc>[s"syiW1z="tyiW:let @l=line('.')<bar>let @c=virtcol('.')<CR>``a<C-g>u<Esc>:echo getreg('l') . ":" . getreg('c') . " spell fixed (" . getreg('s') . " -> " . getreg('t') . ")"<CR>la
    "           \| nnoremap <silent><buffer> z= z=
    "         \| endif
    " augroup END
  ]])
end
