" Disable netrw.
let g:loaded_netrw  = 1
let g:loaded_netrwPlugin = 1
let g:loaded_netrwSettings = 1
let g:loaded_netrwFileHandlers = 1

augroup my-fern-hijack
  autocmd!
  autocmd BufEnter * ++nested call s:hijack_directory()
augroup END

function! s:hijack_directory() abort
  let path = expand('%:p')
  if !isdirectory(path)
    return
  endif
  bwipeout %
  execute printf('Fern %s', fnameescape(path))
endfunction

let g:fern#renderer = "nerdfont"
let g:fern_git_status#disable_ignored = 1
let g:fern_git_status#disable_untracked = 1
let g:fern_git_status#disable_submodules = 1

" Custom settings and mappings.
let g:fern#disable_default_mappings = 1


function! s:init_fern() abort
  nmap <buffer><expr>
        \ <Plug>(fern-my-open-expand-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-open)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )

  nmap <buffer><expr>
        \ <Plug>(fern-my-expand-or-collapse)
        \ fern#smart#leaf(
        \   "\<Plug>(fern-action-collapse)",
        \   "\<Plug>(fern-action-expand)",
        \   "\<Plug>(fern-action-collapse)",
        \ )

  nmap <buffer> <CR> <Plug>(fern-my-open-expand-collapse)
  nmap <buffer><nowait> h <Plug>(fern-action-collapse)
  nmap <buffer><nowait> l <Plug>(fern-my-expand-or-collapse)
  nmap <buffer><nowait> < <Plug>(fern-action-leave)
  nmap <buffer><nowait> > <Plug>(fern-action-enter)
  nmap <buffer><nowait> c <Plug>(fern-action-copy)
  nmap <buffer><nowait> m <Plug>(fern-action-move)
  nmap <buffer><nowait> R <Plug>(fern-action-rename)
  nmap <buffer><nowait> N <Plug>(fern-action-new-path)
  nmap <buffer><nowait> D <Plug>(fern-action-remove)
  nmap <buffer><nowait> r <Plug>(fern-action-reload)
  nmap <buffer><nowait> C <Plug>(fern-action-clipboard-copy)
  nmap <buffer><nowait> M <Plug>(fern-action-clipboard-move)
  nmap <buffer><nowait> P <Plug>(fern-action-clipboard-paste)
  nmap <buffer><nowait> s <Plug>(fern-action-open:split)
  nmap <buffer><nowait> gs <Plug>(fern-action-open:split)<C-w>p
  nmap <buffer><nowait> v <Plug>(fern-action-open:vsplit)
  nmap <buffer><nowait> gv <Plug>(fern-action-open:vsplit)<C-w>p
  nmap <buffer><nowait> H <Plug>(fern-action-mark:toggle)
  nmap <buffer><nowait> L <Plug>(fern-action-mark:toggle)
  nmap <buffer><nowait> J <Plug>(fern-action-mark:toggle)j
  nmap <buffer><nowait> K <Plug>(fern-action-mark:toggle)k
  nmap <buffer><nowait> , <Plug>(fern-action-hidden:toggle)
  " Note: Requires lambdalisue/fern-mapping-project-top.vim
  nmap <buffer><nowait> ^ <Plug>(fern-action-project-top:reveal)
endfunction

augroup fern-custom
  autocmd! *
  autocmd FileType fern call s:init_fern()
  " Startup workaround
  autocmd FileType fern call fern_git_status#init()
augroup END

augroup my-glyph-palette
  autocmd! *
  autocmd FileType fern,startify call glyph_palette#apply()
augroup END

