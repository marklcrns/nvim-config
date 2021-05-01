
" NOTES: When uninstalled, set back to showmode to see status line modes
set noshowmode
let g:lightline = {
  \ 'colorscheme': 'nord',
  \ 'component': {
  \   'lineinfo': '%3l:%-2v',
  \ },
  \ 'component_function': {
  \   'zoom' : 'zoom#statusline',
  \   'cocstatus': 'coc#status',
  \   'currentfunction': 'CocCurrentFunction',
  \   'readonly': 'LightlineReadonly',
  \   'gitstatus': 'LightlineGitStatus',
  \   'gutentags': 'gutentags#statusline',
  \   'method' : 'NearestMethodOrFunction'
  \ },
  \ 'separator': { 'left': '', 'right': '' },
  \ 'subseparator': { 'left': '', 'right': '' },
  \ 'active': {
  \   'left': [ [ 'mode', 'paste' ],
  \             [ 'gitstatus', 'readonly', 'filename', 'modified' ],
  \             [ 'cocstatus', 'currentfunction', 'zoom' ] ],
  \  'right': [ [ 'percent', 'lineinfo' ],
  \            [ 'method' ], [ 'gutentags' ] ]
  \ },
  \ }
  "\ 'component_function': {
  "\   'fugitive': 'LightlineFugitive',
  "\ },

" Ref:
" https://github.com/neoclide/coc.nvim/wiki/Statusline-integration
function! CocCurrentFunction()
    return get(b:, 'coc_current_function', '')
endfunction

function! LightlineReadonly()
  return &readonly ? '' : ''
endfunction

function! LightlineGitStatus() abort
  let status = get(g:, 'coc_git_status', '')
  return status
endfunction

" Gutentags Statusline
augroup MyGutentagsStatusLineRefresher
  autocmd!
  autocmd User GutentagsUpdating call lightline#update()
  autocmd User GutentagsUpdated call lightline#update()
augroup END

" Vista Statusline
function! NearestMethodOrFunction() abort
  return get(b:, 'vista_nearest_method_or_function', '')
endfunction

" Disables lightline tabline for vim-buffet
let g:lightline.enable = {
    \ 'statusline': 1,
    \ 'tabline': 0
    \ }


" Deprecated. Integration with fugitive and itchyny/vim-gitbranch
" function! CustomGitBranch()
"   " Returns git branch name, using different gitbranch or fugitive
"   if exists('*gitbranch#name')
"     let branch = gitbranch#name()
"     return branch !=# '' ? ''.branch : ''
"   elseif exists('fugitive#head')
"     let branch = fugitive#head()
"     return branch !=# '' ? ''.branch : ''
"   endif
"   return ''
" endfunction

