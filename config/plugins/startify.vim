
autocmd! FileType startify
autocmd  FileType startify set laststatus=0 showtabline=0
      \| autocmd BufLeave <buffer> set laststatus=2 showtabline=2
autocmd VimEnter * call s:set_startify_left_padding()

let g:startify_enable_special      = 0
let g:startify_enable_unsafe       = 1
let g:startify_files_number        = 10
let g:startify_relative_path       = 1
let g:startify_change_to_dir       = 1
let g:startify_update_oldfiles     = 1
let g:startify_session_autoload    = 1
let g:startify_session_persistence = 1
let g:startify_session_dir = '~/.vim/session'

let g:startify_lists = [
      \ { 'type': 'sessions',  'header': ['   Sessions']       },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

" Centering header
let g:startify_custom_header =
	\ startify#center(startify#fortune#cowsay('', '═','║','╔','╗','╝','╚'))

let g:startify_bookmarks = [
	\ { 'a': '~/.bash_aliases' },
	\ { 'z': '~/.zshrc' },
	\ { 'b': '~/.bashrc' },
	\ { 't': '~/.tmux.conf' },
	\ { 'w': '~/.config/nvim/layers/+tools/whichkey/config.vim' },
	\ { 'vg': '~/.config/nvim/core/general.vim' },
	\ { 'vm': '~/.config/nvim/core/mappings.vim' },
	\ { 'vp': '~/.config/nvim/core/dein/plugins.yaml' },
	\ { 'vc': '~/.config/nvim/layers/+thinkvim/config.vim' },
	\ { 'lp': '~/.config/nvim/.thinkvim.d/local_plugins.yaml' },
	\ { 'ls': '~/.config/nvim/.thinkvim.d/local_settings.vim' },
	\ { 'di': '~/.doom.d/init.el' },
	\ { 'dc': '~/.doom.d/config.el' },
	\ { 'dp': '~/.doom.d/packages.el' },
	\ { 'ei': '~/.emacs.d/init.el' },
	\ ]

let s:footer = [
      \ '',
      \ '   __         _    _        _    _      _         _    ',
      \ '  / /    ___ | |_ ( ) ___  | |_ | |__  (_) _ __  | | __',
      \ ' / /    / _ \| __||/ / __| | __|| |_ \ | || |_ \ | |/ /',
      \ '/ /___ |  __/| |_    \__ \ | |_ | | | || || | | ||   < ',
      \ '\____/  \___| \__|   |___/  \__||_| |_||_||_| |_||_|\_\',
      \ '                                                       ',
      \ '             [ ThinkVim   Author:taigacute ]           ',
      \ '',
      \ ]

function! s:center(lines) abort
  let longest_line   = max(map(copy(a:lines), 'strwidth(v:val)'))
  let centered_lines = map(copy(a:lines),
        \ 'repeat(" ", (&columns / 2) - (longest_line / 2)) . v:val')
  return centered_lines
endfunction

let g:startify_custom_footer = s:center(s:footer)

function! s:set_startify_left_padding() abort
  let g:startify_padding_left = winwidth(0)/2 - 20
endfunction
