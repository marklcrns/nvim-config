augroup ILoveCorrections
  autocmd!
  autocmd Filetype markdown,vimwiiki,norg
        \ autocmd BufEnter * if get(g:, 'loaded_vim_you_autocorrect', 0) 
        \| exec 'EnableAutocorrect'
        \| let g:vim_you_autocorrect = v:true
        \| endif
augroup END

function! ToggleAutoCorrect() abort
  if get(g:, 'vim_you_autocorrect', 0) ==# v:true
    exec "DisableAutocorrect"
    let g:vim_you_autocorrect=v:false
    echo "Autocorrect Disabled"
  else
    exec "EnableAutocorrect"
    let g:vim_you_autocorrect=v:true
    echo "Autocorrect Enabled"
  endif
endfunction

