
let g:vimwiki_list = [
      \   { 'path': '~/Docs/wiki/wiki/md/',
      \     'path_html': '~/Docs/wiki/wiki/html',
      \     'diary_header': 'Todo',
      \     'diary_link_fmt': '%Y-%m/%d',
      \     'index': 'index',
      \     'auto_tags': 1,
      \     'auto_toc': 0,
      \     'auto_export': 1,
      \     'automatic_nested_syntaxes':1,
      \     'syntax': 'markdown',
      \     'ext': '.md',
      \     'template_path': '~/Docs/wiki/templates/',
      \     'template_default': 'template',
      \     'template_ext':'.html',
      \     'custom_wiki2html': '$VIM_PATH/layers/+tools/vimwiki/wiki2html.sh' },
      \   { 'path': '~/Docs/wiki/docs/md/',
      \     'path_html': '~/Docs/wiki/docs/html',
      \     'index': 'index',
      \     'auto_tags': 1,
      \     'auto_toc': 0,
      \     'auto_export': 1,
      \     'automatic_nested_syntaxes':1,
      \     'syntax': 'markdown',
      \     'ext': '.md',
      \     'template_path': '~/Docs/wiki/templates/',
      \     'template_default': 'template',
      \     'template_ext':'.html',
      \     'custom_wiki2html': '$VIM_PATH/layers/+tools/vimwiki/wiki2html.sh' },
      \   { 'path': '~/Docs/wiki/school/md',
      \     'path_html': '~/Docs/wiki/school/html',
      \     'index': 'index',
      \     'auto_tags': 1,
      \     'auto_toc': 0,
      \     'auto_export': 1,
      \     'automatic_nested_syntaxes':1,
      \     'syntax': 'markdown',
      \     'ext': '.md',
      \     'template_path': '~/Docs/wiki/templates/',
      \     'template_default': 'template',
      \     'template_ext':'.html',
      \     'custom_wiki2html': '$VIM_PATH/layers/+tools/vimwiki/wiki2html.sh' },
      \ ]

" Custom link handler for external files
" Use Vim to open external files with the 'vfile:' scheme.  E.g.:
"   1) [[vfile:~/absolute_path/to/file/]]
"   2) [[vfile:./relative_path/to/file]]
" Use xdg-open to open external file with the 'file:' scheme. E.g:
"   1) [[file:~/absolute_path/to/file/]]
"   2) [[file:./relative_path/to/file]]
" For markdown syntax
"   Open with Vim
"   1) [Description](vfile:~/absolute_path/to/file)
"   2) [Description](vfile:./relative_path/to/file)
"   Open with xdg-open
"   1) [Description](file:~/absolute_path/to/file)
"   2) [Description](file:./relative_path/to/file)
function! VimwikiLinkHandler(link)
  let link = a:link
  if link =~# '^vfile:'
    let link_infos = vimwiki#base#resolve_link(link[1:])
  elseif link=~# '^file:'
    let link_infos = vimwiki#base#resolve_link(link)
  else
    return 0
  endif
  if link_infos.filename == ''
    echomsg 'Vimwiki Error: Unable to resolve link!'
    return 0
  elseif link =~# '^file:'
    try
      if vimwiki#u#is_windows()
        call s:win32_handler(link)
        return 1
      elseif vimwiki#u#is_macos()
        call s:macunix_handler(link)
        return 1
      else
        call s:linux_handler(link)
        return 1
      endif
    catch
      echo "Error while opening " . fnameescape(link_infos.filename)
    endtry
    return 0
  else
    exe 'vsplit ' . fnameescape(link_infos.filename)
    return 1
  endif
endfunction

" TODO: Check if reference header exists, if not make one
" TODO: Do not overwrite on existing list sublists
" Resources:
" Copy search match                   = https://vim.fandom.com/wiki/Copy_search_matches
" Undupe list                         = https://stackoverflow.com/a/6630950/11850077
" Match all characters with new lines = https://vi.stackexchange.com/a/13991
" Extras:
" https://vim.fandom.com/wiki/Folding_with_Regular_Expression
" ----------
function! CopyMatches(reg)
  let hits = []
  " Add all matches into hits list
  silent %s//\=len(add(hits, submatch(0))) ? submatch(0) : ''/gne
  " Get register name. Use '+' if not provided
  let reg = empty(a:reg) ? '+' : a:reg
  " Replace in-between new lines/line breaks with single space from each matches
  let cleanhits = map(copy(hits), 'substitute(v:val, "\\n\\(\\s*\\|\\t*\\)\\?", " ", "g")')
  " Filter out duplicate matches
  let undupehits = filter(copy(cleanhits), 'index(cleanhits, v:val, v:key+1)==-1')
  " Put all list of strings joined by new lines into register
  exe 'let @'.reg.' = "\n" . join(undupehits, "\n") . "\n"'
endfunction
command! -register CopyMatches call CopyMatches(<q-reg>)

function! IndexResourcesLinks(header, pattern)
  " Save cursor position
  let save_pos = getpos(".")
  " Use default link pattern in non was given
  " Note: \_.\{-} regex pattern matches all characters including new lines.
  let pattern = empty(a:pattern) ? '^\([-*]\s\|[^+]*\)\zs\[[⬇📄📑💽📺]\_.\{-}\](\_.\{-})' : a:pattern
  " Check if pattern matched
  if search(pattern, 'w') == 0
    echo "No link pattern match found"
    return
  endif

  " Use default '# Resources' header of non was given
  let header = empty(a:header) ? '# Resources' : a:header
  if search(header, 'w') == 0
    " Create header if not found. Also adds '<br>' tag before the header
    exe "norm! Go\<CR><br>\<CR>\<CR>" . header
  endif

  " Delete exising links under the header
  exe 'silent g/' . header . '/'
  silent exe "norm! jVG:g/-\\s\\[.*\\](.*)/d\<CR>"

  " Clear `x` register and copy all matched reference links into it
  exe 'let @x = ""'
  " Yank all links matched with pattern
  exe 'silent g/' . pattern . '/y A'
  " Copy all matches in 'x' register and ready for pasting
  call CopyMatches('x')

  " Check if resources header exist
  if search(header, 'w') == 0
    echom 'Error IndexResourcesLinks(): ' . header . ' header not found'
    return
  endif
  exe 'silent g/' . header . '/'
  " Paste all links under the header
  silent exe 'norm! "xp'

  " Prepend '- ' on every pasted matched links. 'j' after '`[' offsets extra
  " empty line at the beginning of selection, and 'jdd' at the end deletes
  " extra empty line at the end.
  silent exe "norm! `[jv`]:s/\\(.*\\)/- \\1/\<CR>`]jdd"
  " Add back new line if the following line is not empty and not a link
  let nextline = getline('.')
  if (len(nextline) > 0) && !(nextline =~ pattern)
    exe 'norm! O'
  endif
  " Clear highlights
  nohls
  " Go back to last cursor position centered
  call setpos('.', save_pos)
  exe 'norm! zz'
  " Report complete
  redraw
  echo "Auto generated Resources header"
endfunction

" Deprecated by coc-spell-checker
" augroup SpellCheck
"   autocmd!
"   autocmd Filetype vimwiki
"        \ autocmd BufRead <buffer> setlocal spell
" augroup END

augroup VimwikiEditMode
  autocmd!
  autocmd FileType vimwiki setlocal textwidth=80
  autocmd FileType vimwiki setlocal foldlevel=99
  autocmd FileType vimwiki setlocal nowrap
  " Toggle conceallevel on and after insert mode
  autocmd FileType vimwiki
        \ autocmd InsertEnter <buffer> setlocal conceallevel=0
  autocmd FileType vimwiki
        \ autocmd InsertLeave <buffer> setlocal conceallevel=2
  " Auto-indent, select, and auto-wrap texts at textwidth 80 after pasting.
  " Useful for long lines. Depends on `gp` nmap. For more info `:verbose nmap gp`
  autocmd FileType vimwiki
        \ imap <expr><silent><buffer> <M-p> pumvisible() ? "\<C-e>\<Esc>:call SmartInsertPaste()\<CR>" : "\<Esc>:call SmartInsertPaste()\<CR>"
augroup END

function! SubstituteOddChars()
  " `e` flag silence errors, see `s_flags'
  " TODO: turn into independent function with visual and normal mode support,
  " and accepts arbitrary args for odd chars
  silent exe "norm! gv:s/“/\"/ge\<CR>"
  silent exe "norm! gv:s/”/\"/ge\<CR>"
  silent exe "norm! gv:s/’/'/ge\<CR>"
  silent exe "norm! gv:s/—/--/ge\<CR>"
  silent exe "norm! gv:s/…/.../ge\<CR>"
  silent exe "norm! gv:s/•/-/ge\<CR>"
  silent exe "norm! gv:s/ ,/,/ge\<CR>"
  silent exe 'norm! gv:s/  /\r\r/ge'."\<CR>"
  silent exe "norm! gv:s/   / /ge\<CR>"
  silent exe "norm! gv:s/ \\././ge\<CR>"
  silent exe "norm! gv:s/​//ge\<CR>"
  " Add (if not already) a backslash '\' in front of currencies
  " e.g., $10,000 -> \$10,000
  silent exe 'norm! gv:s/\(\\\)\@<!\((\)\?\$\([0-9,.]\+\)\(\s\|\n\|)\)/\2\\$\3\4/ge'."\<CR>"
  " Clear commandline prompt
  redraw
endfunction

" Ref:
" Select last pasted line(s): https://vim.fandom.com/wiki/Selecting_your_pasted_text
function! SmartInsertPaste()
  " Paste and indent pasted
  exe "norm! \<M-p>`[v`]="
  " Remove whitespace
  exe "norm! gv:WhitespaceErase\<CR>"
  " Substitute odd chars
  call SubstituteOddChars()
  " Reindent and format lines
  exe "norm! gv=gvgw"
  echo "SmartInsertPaste complete"
  " Go to the end of the last selected texts
  exe "norm! 0`>"
endfunction

" Ref: https://stackoverflow.com/a/61275100/11850077
"      https://github.com/vim/vim/issues/2004#issuecomment-324357529
function! IntegratedVimwikiTab() abort
  " First, try to expand or jump on UltiSnips.
  let snippet = UltiSnips#ExpandSnippet()
  if g:ulti_expand_res > 0
    return snippet
  endif
  " Then, check if we're in a completion menu
  if pumvisible()
    return coc#_select_confirm()
  endif
  " Finally, trigger vimwiki table jump.
  return vimwiki#tbl#kbd_tab()
endfunction

" Vimwiki custom mappings
augroup VimwikiCustomMappings
  autocmd!
  " Integration with delimitMate, coc completion and Ultisnips
  autocmd FileType vimwiki inoremap <silent><buffer> <Tab>
        \ <C-R>=IntegratedVimwikiTab()<CR>
  autocmd Filetype vimwiki inoremap <silent><buffer><expr> <S-tab>
        \ vimwiki#tbl#kbd_shift_tab()
  autocmd Filetype vimwiki inoremap <silent><buffer><expr> <CR>
        \ delimitMate#WithinEmptyPair() ?
        \ "\<C-R>=delimitMate#ExpandReturn()\<CR>" :
        \ "\<ESC>:VimwikiReturn 1 5\<CR>"
  autocmd FileType vimwiki inoremap <silent><buffer> <CR>
              \ <C-]><Esc>:VimwikiReturn 1 5<CR>
  autocmd FileType vimwiki inoremap <silent><buffer> <S-CR>
              \ <Esc>:VimwikiReturn 4 1<CR>
  autocmd Filetype vimwiki nnoremap <silent><buffer><LocalLeader>wL :call IndexResourcesLinks('# Resources', '')<CR>
  " Dependent on `q` mapping to exec `bdelete`. Somehow <S-CR> on normal don't work
  " autocmd Filetype vimwiki nmap <buffer><Leader><CR> :VimwikiFollowLink<CR>mZ<C-o>q`ZmZ
  " autocmd Filetype vimwiki nmap <buffer><Leader><BS> :VimwikiGoBackLink<CR>mZ<C-o>q`ZmZ
augroup END

" Quick fix hack on <CR> and <S-CR> being remapped when comming back to a session
if !hasmapto('VimwikiReturn', 'i')
  if maparg('<CR>', 'i') !~? '<Esc>:VimwikiReturn'
    inoremap <silent><buffer><expr> <CR>
          \ delimitMate#WithinEmptyPair() ?
          \ "\<C-R>=delimitMate#ExpandReturn()\<CR>" :
          \ "\<ESC>:VimwikiReturn 1 5\<CR>"
  endif
  if maparg('<S-CR>', 'i') !~? '<Esc>:VimwikiReturn'
    inoremap <silent><buffer> <S-CR> <Esc>:VimwikiReturn 4 1<CR>
  endif
endif
