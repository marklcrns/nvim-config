" Startify
" ---

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
      \ { 'type': 'dir',       'header': ['   MRU '. getcwd()] },
      \ { 'type': 'files',     'header': ['   MRU']            },
      \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
      \ { 'type': 'commands',  'header': ['   Commands']       },
      \ ]

" Centering header
let g:startify_custom_header =
      \ startify#center(startify#fortune#cowsay('', '═','║','╔','╗','╝','╚'))

let g:startify_bookmarks = [
      \ { 'a': '~/.bash_aliases' },
      \ { 'b': '~/.bashrc' },
      \ { 'p': '~/.profile' },
      \ { 't': '~/.tmux.conf' },
      \ { 'z': '~/.zshrc' },
      \ ]

let s:footer = [
      \ '                                                  _|      ',
      \ '      _|      _|                      _|        _|        ',
      \ '      _|_|  _|_|    _|_|_|  _|  _|_|  _|  _|        _|_|_|',
      \ '      _|  _|  _|  _|    _|  _|_|      _|_|        _|_|    ',
      \ '      _|      _|  _|    _|  _|        _|  _|          _|_|',
      \ '      _|      _|    _|_|_|  _|        _|    _|    _|_|_|  ',
      \ '',
      \ '_|      _|                                  _|                ',
      \ '_|_|    _|    _|_|      _|_|    _|      _|      _|_|_|  _|_|  ',
      \ '_|  _|  _|  _|_|_|_|  _|    _|  _|      _|  _|  _|    _|    _|',
      \ '_|    _|_|  _|        _|    _|    _|  _|    _|  _|    _|    _|',
      \ '_|      _|    _|_|_|    _|_|        _|      _|  _|    _|    _|',
      \ '',
      \ '                    [ github.com/marklcrns ]',
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
