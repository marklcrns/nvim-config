
let g:dashboard_session_directory = '~/.vim/sessions'
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
      \ 'open_session': {
          \ 'description'     : [' <S>essions                              SPC s f  '],
          \ 'command' : 'Clap sessions'
          \ },
      \ 'find_file': {
          \ 'description'     : [' <F>iles                                 SPC f d f'],
          \ 'command' : 'DashboardFindFile'
          \ },
      \ 'find_history': {
          \ 'description'     : ['ﭯ <H>istory                               SPC f d h'],
          \ 'command': 'DashboardFindHistory'
          \ },
      \ 'book_marks': {
          \ 'description'     : [' <M>arks                                 SPC f d m'],
          \ 'command': 'DashboardJumpMark'
          \ },
      \ 'open_dotfiles': {
          \ 'description'     : [' <.>dotfiles                             SPC f d p'],
          \ 'command': 'Clap personalconf'
          \ },
      \ }

autocmd FileType dashboard noremap <nowait><silent><buffer> . :Clap personalconf<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> e :enew<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> f :DashboardFindFile<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> h :DashboardFindHistory<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> m :DashboardJumpMark<CR>
autocmd FileType dashboard noremap <nowait><silent><buffer> s :Clap sessions<CR>
