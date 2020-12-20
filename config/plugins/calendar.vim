let g:calendar_google_calendar = 1
let g:calendar_google_task = 1
let g:calendar_task_delete = 1
let g:calendar_frame = 'default'
source ~/.cache/calendar.vim/credentials.vim

augroup CalendarMappings
  autocmd!
  " unmap mappings for other plugins
  " autocmd FileType calendar nunmap <buffer> <C-n>
  " autocmd FileType calendar nunmap <buffer> <C-p>
  autocmd FileType calendar silent! nunmap <buffer> <C-h>
  autocmd FileType calendar silent! nunmap <buffer> <C-j>
  autocmd FileType calendar silent! nunmap <buffer> <C-k>
  autocmd FileType calendar silent! nunmap <buffer> <C-l>
augroup END
