
let g:dashboard_session_directory = '$HOME/.vim/sessions'
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
          \ 'command' : 'DashboardFindFile'
          \ },
      \ '2_open_session': {
          \ 'description'     : [' <S>essions                              SPC f d s'],
          \ 'command' : 'Clap sessions'
          \ },
      \ '3_find_history': {
          \ 'description'     : ['ﭯ <H>istory                               SPC f d h'],
          \ 'command': 'DashboardFindHistory'
          \ },
      \ '4_book_marks': {
          \ 'description'     : [' <M>arks                                 SPC f d m'],
          \ 'command': 'DashboardJumpMark'
          \ },
      \ '5_open_dotfiles': {
          \ 'description'     : [' <.>dotfiles                             SPC f d p'],
          \ 'command': 'Clap personalconf'
          \ },
      \ '6_daily_todo': {
          \ 'description'     : [' <T>o-Do daily                               ; w T'],
          \ 'command': 'call DToday()'
          \ },
      \ }

autocmd FileType dashboard noremap <nowait><silent><buffer> . :Clap personalconf<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> e :enew<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> f :DashboardFindFile<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> h :DashboardFindHistory<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> m :DashboardJumpMark<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> s :Clap sessions<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> t :call DToday()<CR>
