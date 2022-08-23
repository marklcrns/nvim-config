let g:dashboard_enable_session = 0

autocmd FileType dashboard noremap <nowait><silent><buffer> e :enew<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> f :Telescope find_files<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> h :Telescope oldfiles<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> m :Telescope marks<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> s :<C-u>call feedkeys(':SessionLoad<Space><Tab>','t')<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> t :call DToday()<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> W :VimwikiUISelect<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> n :Neorg workspace<CR>
