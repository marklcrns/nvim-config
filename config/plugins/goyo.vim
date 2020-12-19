let g:goyo_width=100 "(default: 80)
let g:goyo_height=100 "(default: 85%)
let g:goyo_linenr=1 "(default: 0)

function! s:goyo_enter()
  if has('gui_running')
    " Gui fullscreen
    set fullscreen
  endif
  " Backup and disable some settings
  let g:signcolumn_goyo_bak=&signcolumn
  let g:scrolloff_goyo_bak=&scrolloff
  let g:showmode_goyo_bak=0
  let g:showcmd_goyo_bak=0
  set signcolumn=no
  set scrolloff=999
  if &showmode
    let g:showmode_goyo_bak=1
    set noshowmode
  endif
  if &showcmd
    let g:showcmd_goyo_bak=1
    set noshowcmd
  endif
  " Activate Limelight
  Limelight
endfunction

" Enable visuals when leaving Goyo mode
function! s:goyo_leave()
  if has('gui_running')
    " Gui exit fullscreen
    set nofullscreen
  endif
  " Restore backed up settings
  execute "set signcolumn=" . g:signcolumn_goyo_bak
  execute "set scrolloff=" . g:scrolloff_goyo_bak
  if g:showmode_goyo_bak
    set showmode
  endif
  if g:showcmd_goyo_bak
    set showcmd
  endif
  " Source custom colors
  source $VIM_PATH/core/color.vim
  " De-activate Limelight
  Limelight!
endfunction

augroup user_plugin_goyo
  autocmd!
  autocmd! User GoyoEnter
  autocmd! User GoyoLeave
  autocmd  User GoyoEnter nested call <SID>goyo_enter()
  autocmd  User GoyoLeave nested call <SID>goyo_leave()
  " Auto resize goyo width and height when resized or toggled fullscreen
  autocmd VimResized * if exists('#goyo') | exe "normal \<c-w>=" | endif
augroup END

