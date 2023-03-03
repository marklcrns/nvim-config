" Theme

function! theme#init()
  " Reset g:colors_name
  if exists('g:colors_name')
    unlet g:colors_name
  endif
  
  " Load cached colorscheme or hybrid by default
  let l:default = 'custom_hybrid_reverse'
  let l:scheme = s:theme_cached_scheme(l:default)

  set background=dark

  try
    execute 'colorscheme' l:scheme
  catch /^Vim\%((\a\+)\)\=:E185/
    execute 'colorscheme' l:default
  endtry

  autocmd VimEnter,ColorScheme * call utils#source_file($VIM_PATH, 'core/colors.vim')
endfunction

function! s:theme_autoload()
  if exists('g:colors_name')
    let theme_path = $VIM_PATH . '/colors/' . g:colors_name . '.vim'
    if filereadable(theme_path)
      execute 'source' fnameescape(theme_path)
    endif
    " Persist theme
    if get(g:, 'custom_colorscheme_persist', 1)
      call writefile([g:colors_name], s:theme_cache_file())
    endif
  endif
endfunction

function! s:theme_cache_file()
  return $DATA_PATH . '/theme.txt'
endfunction

function! s:theme_cached_scheme(default)
  let l:cache_file = s:theme_cache_file()
  return filereadable(l:cache_file) ? readfile(l:cache_file)[0] : a:default
endfunction

function! s:theme_cleanup()
  if ! exists('g:colors_name')
    return
  endif
  highlight clear
endfunction

augroup user_theme
  autocmd!
  autocmd ColorScheme * call s:theme_autoload()
  if has('patch-8.0.1781') || has('nvim-0.3.2')
    autocmd ColorSchemePre * call s:theme_cleanup()
  endif
augroup END

