let g:vim_you_autocorrect=v:false
let g:vim_you_autocorrect_autotoggle=v:true

function! ToggleAutoCorrect() abort
  if get(g:, 'vim_you_autocorrect_autotoggle', v:false)
    exec "DisableAutocorrect"
    let g:vim_you_autocorrect=v:false
    let g:vim_you_autocorrect_autotoggle=v:false
    echo "Autocorrect Disabled"
  else
    exec "EnableAutocorrect"
    let g:vim_you_autocorrect=v:true
    let g:vim_you_autocorrect_autotoggle=v:true
    echo "Autocorrect Enabled"
  endif
endfunction

augroup ILoveCorrections
  autocmd!
  autocmd BufEnter *
        \ if (&ft ==# 'markdown' || &ft ==# 'vimwiki' || &ft ==# 'norg') && get(g:, 'loaded_vim_you_autocorrect', 0) && get(g:, 'vim_you_autocorrect_autotoggle', v:false)
          \| exec "EnableAutocorrect"
          \| let g:vim_you_autocorrect=v:true
        \| endif
  autocmd BufLeave *
        \ if (&ft ==# 'markdown' || &ft ==# 'vimwiki' || &ft ==# 'norg') && get(g:, 'loaded_vim_you_autocorrect', 0) && get(g:, 'vim_you_autocorrect_autotoggle', v:false)
          \| exec "DisableAutocorrect"
          \| let g:vim_you_autocorrect=v:false
        \| endif
augroup END

