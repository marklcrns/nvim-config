augroup user_plugin_filetype "{{{
  autocmd!

  " Disable swap/undo/viminfo/shada files in temp directories or shm
  silent! autocmd BufNewFile,BufReadPre
        \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
        \ setlocal noswapfile noundofile nobackup nowritebackup viminfo= shada=

  " Trigger `autoread` when files changes on disk
  " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
  " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif

  " Notification after file change
  " https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
  autocmd FileChangedShellPost *
        \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None

  " Disables automatic commenting on newline:
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

  " Reload vim config automatically
  autocmd BufWritePost $VIM_PATH/{*.vim,*.yaml,vimrc} nested
        \ source $MYVIMRC | redraw

  " Reload Vim script automatically if setlocal autoread
  autocmd BufWritePost,FileWritePost *.vim nested
        \ if &l:autoread > 0 | source <afile> |
        \   echo 'source ' . bufname('%') |
        \ endif

  " Update filetype on save if empty
  autocmd BufWritePost * nested
        \ if &l:filetype ==# '' || exists('b:ftdetect')
        \ |   unlet! b:ftdetect
        \ |   filetype detect
        \ | endif

  " Automatically set read-only for files being edited elsewhere
  autocmd SwapExists * nested let v:swapchoice = 'o'

  " " Equalize window dimensions when resizing vim window
  " autocmd VimResized * tabdo wincmd =

  " Force write shada on leaving nvim
  autocmd VimLeave * if has('nvim') | wshada! | else | wviminfo! | endif

  " Check if file changed when its window is focus, more eager than 'autoread'
  autocmd FocusGained * checktime

  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif

  autocmd Syntax * if line('$') > 5000 | syntax sync minlines=200 | endif

  " https://webpack.github.io/docs/webpack-dev-server.html#working-with-editors-ides-supporting-safe-write
  autocmd FileType css,javascript,javascriptreact setlocal backupcopy=yes

  " Python
  autocmd FileType python
        \ setlocal expandtab smarttab nosmartindent
        \ | setlocal tabstop=4 softtabstop=4 shiftwidth=4 textwidth=80

  " Makefile
  autocmd FileType make
        \ setlocal noexpandtab tabstop=8 softtabstop=8 shiftwidth=8

  " HTML (.gohtml and .tpl for server side)
  autocmd BufNewFile,BufRead *.html,*.htm,*.gohtml,*.tpl  setf html
augroup END "}}}

augroup user_cursorui
  let ft_exclusion = '^\(denite\|clap_\)'
  autocmd!
  autocmd InsertEnter,WinLeave,FocusLost * if (get(g:, 'custom_cursorline_enable', 1) || get(g:, 'custom_cursorcolumn_enable', 0)) && (&ft !~# ft_exclusion)
        \| setlocal nocursorline nocursorcolumn
        \| endif
  autocmd InsertLeave,WinEnter,BufWinEnter,FocusGained * if get(g:, 'custom_cursorline_enable', 1) && (&ft !~# ft_exclusion)
        \| setlocal cursorline
        \| endif
  autocmd InsertLeave,WinEnter,BufWinEnter,FocusGained * if get(g:, 'custom_cursorcolumn_enable', 0) && (&ft !~# ft_exclusion)
        \| setlocal cursorcolumn
        \| endif
augroup END
