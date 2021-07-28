
let g:dashboard_enable_session = 0
" Credits: https://github.com/66RING/.vim/blob/master/config/plugin_config.vim
let g:dashboard_custom_header = [
      \'',
      \'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
      \'⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣼⣿⣦⢀⡐⠀⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠀',
      \'⠀⠀⠀⠀⠀⠀⠠⢀⠠⢚⡉⠘⢰⣾⣿⣿⣿⣷⠀⠈⢈⠒⢀⠀⠀⠀⠀⠀⠀⠀⠀',
      \'⠀⠀⠀⠀⢀⠠⠈⠑⣄⣠⠽⣰⣿⢿⣾⢾⣿⢻⣿⣰⠯⣀⣨⠋⢀⢀ ⠀⠀⠀⠀',
      \'⠀⠀⢀⢠⠈⠈⢶⣔⠉⢳⣴⣿⣻⢰⢽⢼⠯⢼⢻⣿⣦⠾⠹⣠⠶⠁⠑⣀⡀⠀⠀',
      \'⠀⠀⣀⠉⠐⣶⣉⣨⢻⣾⣿⠹⢤⢞⢸⢸⢏⡺⢼⢩⢿⣶⠛⢁⣩⣴⠊⢉⢀⠀⠀',
      \'⠀⠨⢁⠒⢴⣭⣰⣉⣿⣟⢶⣴⣾⣾⣿⣿⣿⣿⣶⣬⠺⣻⣽⣉⣠⣬⡶⠒⠘⠀⠀',
      \' ⢾⠴⠤⣯⣤⣴⣽⣻⣾⣿⠿⣿⠟⣿⣿⣿⢻⡿⠿⣿⣷⣝⣽⣤⢤⣽⠴⢴⢶⠀',
      \'⠀⣌⣀⣠⣭⣴⣾⢿⢿⣷⣀⢀⠘⣶⣙⢟⣋⣾⠃⢀⣠⣾⣿⢿⣿⣦⣼⣠⣸⣠⠀',
      \'⠀⢈⠠⢀⣿⣿⣉⣸⢤⢙⣻⢿⣶⣶⣭⣭⣭⣴⣶⠿⢯⢻⢴⣀⣹⢿⣿⡀⠀⠁⠀',
      \'⠀ ⢡⣿⣾⠙⢙⣠⢜⢤⣰⢋⢾⣝⢹⢻⡟⣫⢵⢸⢼⢼⢺⣠⣩⢻⣾⣿⡘⠀⠀',
      \'⠀⣰⣿⢿⣾⢿⣾⣿⣾⢿⣿⣾⣾⣾⣿⣾⢿⢾⣾⣿⣿⣿⣾⣿⣷⢿⢿⢿⢾⣄⠀',
      \'⠀⠀⠀⠀⠨⢊⠠⢀⠾⢠⣠⠞⠀⣰⠐⢰⢀⣲⢀⢺⣐⠜⢶⠀⢀⠱⢀⠀⠀⠀⠀',
      \'⠀⠀⠀⠀⠀⠀⠨⠒⠠⢀⠟⠀⢹⠉⠀⣿⠘⠸⠉⠀⠻⣐⠀⠒⠀⠀⠀⠀⠀⠀⠀',
      \'⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠉⠀⠒⠐⠠⠿⠘⠐⢒⠈⠉⠑⠀⠀⠀⠀⠀⠀⠀⠀⠀',
      \'',
      \]

let g:dashboard_custom_section = {
      \ '1_find_file': {
          \ 'description'     : [' <F>iles                                 SPC f d f'],
          \ 'command' : 'Telescope find_files'
          \ },
      \ '2_open_session': {
          \ 'description'     : [' <S>essions                              SPC s l  '],
          \ 'command' : 'call feedkeys(":SessionLoad<Space><Tab>","t")'
          \ },
      \ '3_find_history': {
          \ 'description'     : ['ﭯ <H>istory                               SPC f d h'],
          \ 'command': 'Telescope oldfiles'
          \ },
      \ '4_book_marks': {
          \ 'description'     : [' <M>arks                                 SPC f d m'],
          \ 'command': 'Telescope marks'
          \ },
      \ '5_daily_todo': {
          \ 'description'     : [' <T>o-Do daily                               ; w T'],
          \ 'command': 'call DToday()'
          \ },
      \ '6_wiki': {
          \ 'description'     : [' <W>iki                                      ; W W'],
          \ 'command': 'VimwikiUISelect'
          \ },
      \ }

autocmd FileType dashboard noremap <nowait><silent><buffer> e :enew<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> f :Telescope find_files<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> h :Telescope oldfiles<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> m :Telescope marks<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> s :<C-u>call feedkeys(':SessionLoad<Space><Tab>','t')<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> t :call DToday()<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> w :VimwikiUISelect<CR>
