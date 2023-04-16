let g:far#enable_undo=1

if executable('rg')
  let g:far#source = 'rg'
elseif executable('ag')
  let g:far#source = 'ag'
elseif executable('ack')
  let g:far#source = 'ack'
endif

