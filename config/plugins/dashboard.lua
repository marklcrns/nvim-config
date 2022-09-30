local db = require('dashboard')
db.custom_header = {
  '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀',
  '⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣼⣿⣦⢀⡐⠀⠀ ⠀⠀⠀⠀⠀⠀⠀⠀⠀',
  '⠀⠀⠀⠀⠀⠀⠠⢀⠠⢚⡉⠘⢰⣾⣿⣿⣿⣷⠀⠈⢈⠒⢀⠀⠀⠀⠀⠀⠀⠀⠀',
  '⠀⠀⠀⠀⢀⠠⠈⠑⣄⣠⠽⣰⣿⢿⣾⢾⣿⢻⣿⣰⠯⣀⣨⠋⢀⢀ ⠀⠀⠀⠀',
  '⠀⠀⢀⢠⠈⠈⢶⣔⠉⢳⣴⣿⣻⢰⢽⢼⠯⢼⢻⣿⣦⠾⠹⣠⠶⠁⠑⣀⡀⠀⠀',
  '⠀⠀⣀⠉⠐⣶⣉⣨⢻⣾⣿⠹⢤⢞⢸⢸⢏⡺⢼⢩⢿⣶⠛⢁⣩⣴⠊⢉⢀⠀⠀',
  '⠀⠨⢁⠒⢴⣭⣰⣉⣿⣟⢶⣴⣾⣾⣿⣿⣿⣿⣶⣬⠺⣻⣽⣉⣠⣬⡶⠒⠘⠀⠀',
  ' ⢾⠴⠤⣯⣤⣴⣽⣻⣾⣿⠿⣿⠟⣿⣿⣿⢻⡿⠿⣿⣷⣝⣽⣤⢤⣽⠴⢴⢶⠀',
  '⠀⣌⣀⣠⣭⣴⣾⢿⢿⣷⣀⢀⠘⣶⣙⢟⣋⣾⠃⢀⣠⣾⣿⢿⣿⣦⣼⣠⣸⣠⠀',
  '⠀⢈⠠⢀⣿⣿⣉⣸⢤⢙⣻⢿⣶⣶⣭⣭⣭⣴⣶⠿⢯⢻⢴⣀⣹⢿⣿⡀⠀⠁⠀',
  '⠀ ⢡⣿⣾⠙⢙⣠⢜⢤⣰⢋⢾⣝⢹⢻⡟⣫⢵⢸⢼⢼⢺⣠⣩⢻⣾⣿⡘⠀⠀',
  '⠀⣰⣿⢿⣾⢿⣾⣿⣾⢿⣿⣾⣾⣾⣿⣾⢿⢾⣾⣿⣿⣿⣾⣿⣷⢿⢿⢿⢾⣄⠀',
  '⠀⠀⠀⠀⠨⢊⠠⢀⠾⢠⣠⠞⠀⣰⠐⢰⢀⣲⢀⢺⣐⠜⢶⠀⢀⠱⢀⠀⠀⠀⠀',
  '⠀⠀⠀⠀⠀⠀⠨⠒⠠⢀⠟⠀⢹⠉⠀⣿⠘⠸⠉⠀⠻⣐⠀⠒⠀⠀⠀⠀⠀⠀⠀',
  '⠀⠀⠀⠀⠀⠀⠀⠀⠀ ⠉⠀⠒⠐⠠⠿⠘⠐⢒⠈⠉⠑⠀⠀⠀⠀⠀⠀⠀⠀⠀',
}

db.custom_center = {
  {
    icon = '  ',
    desc = '<f>iles                                 ',
    shortcut = 'SPC f d f',
    action = 'Telescope find_files',
  },
  {
    icon = '  ',
    desc = '<s>essions                              ',
    action = 'call feedkeys(":SeshLoad<Space><Tab>","t")',
    shortcut = 'SPC s l  ',
  },
  {
    icon = 'ﭯ  ',
    desc = '<h>istory                               ',
    action = 'Telescope oldfiles',
    shortcut = 'SPC f d h',
  },
  {
    icon = '  ',
    desc = '<m>arks                                 ',
    action = 'Telescope marks',
    shortcut = 'SPC f d m',
  },
  {
    icon = '  ',
    desc = '<t>o-Do daily                               ',
    action = 'call DToday()',
    shortcut = '; w T',
  },
  {
    icon = '  ',
    desc = '<W>iki                                      ',
    action = 'VimwikiUISelect',
    shortcut = '; W W',
  },
  {
    icon = '  ',
    desc = '<n>eorg                                     ',
    action = 'Neorg workspace main',
    shortcut = '; n w',
  },
}


vim.cmd([[
  augroup dashboard_enter
    au!
    autocmd FileType dashboard noremap <nowait><silent><buffer> e :enew<CR>
    autocmd FileType dashboard noremap <nowait><silent><buffer> f :Telescope find_files<CR>
    autocmd FileType dashboard noremap <nowait><silent><buffer> h :Telescope oldfiles<CR>
    autocmd FileType dashboard noremap <nowait><silent><buffer> m :Telescope marks<CR>
    autocmd FileType dashboard noremap <nowait><silent><buffer> s :<C-u>call feedkeys(':SeshLoad<Space><Tab>','t')<CR>
    autocmd FileType dashboard noremap <nowait><silent><buffer> t :call DToday()<CR>
    autocmd FileType dashboard noremap <nowait><silent><buffer> W :VimwikiUISelect<CR>
    autocmd FileType dashboard noremap <nowait><silent><buffer> n :Neorg workspace main<CR>
  augroup END
]])
