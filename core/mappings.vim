" ==================== Mappings ==================== "

" Leaders + Nop prefixes + ExitMappings + ImprovedDefaultMappings +
" ExtendedBasicMappings + OperatorMappings are now defined in
" lua/user/core/mappings_vim.lua

" HELPER FUNCTIONS -------------------- {{{

" Increment/Decrement integer
function! AddSubtract(char, back)
  let pattern = &nrformats =~ 'alpha' ? '[[:alpha:][:digit:]]' : '[[:digit:]]'
  call search(pattern, 'cw' . a:back)
  execute 'normal! ' . v:count1 . a:char
  silent! call repeat#set(":\<C-u>call AddSubtract('" .a:char. "', '" .a:back. "')\<CR>")
endfunction

" Returns visually selected text
function! GetSelection(cmdtype)
  let temp = @s
  normal! gv"sy
  let @/ = substitute(escape(@s, '\'.a:cmdtype), '\n', '\\n', 'g')
  let @s = temp
endfunction

" Preserve last search and cursor position before running a:command
function! Preserve(command)
  " Save search and cur pos
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Execute command
  execute a:command
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

function! ShiftCharAscii(char, shift)
  let nr = char2nr(a:char)
  execute 'normal! r' . nr2char(nr + a:shift)
endfunction

function! VShiftCharAscii(shift)
  let [line_start, column_start] = getpos("'<")[1:2]
  let [line_end, column_end] = getpos("'>")[1:2]
  let lines = getline(line_start, line_end)
  if len(lines) == 0
    return ''
  endif
  let lines[-1] = lines[-1][: column_end - 1]
  let lines[0] = lines[0][column_start - 1:]

  let str = join(lines, "\n")

  let res = ""
  for i in range(0, len(str) - 1)
    let res = res . nr2char(char2nr(str[i]) + a:shift)
  endfor

  let clipboard = getreg('+')
  let @+ = res
  execute 'normal! gvpgv'
  let @+ = clipboard
endfunction

" Load all a:input value from files of the same extension as the current
" buffer within project directory.
" Ref: https://stackoverflow.com/a/4106211/11850077
function! VimgrepWrapper(input, ...)
  " arg2 'c' for ignorecasing and 'C' for match casing
  let casing = get(a:, 1, "")
  let ext = expand("%:e")
  " Find files only with same extension as current buffer if theres a file
  " extension, else no file type filter.
  if ext
    exec "noautocmd vimgrep /\\" . casing . a:input . "/j **/*." . expand("%:e")
  else
    exec "noautocmd vimgrep /\\" . casing . a:input . "/j **/*"
  endif
  exec "cw"
endfunction

" Auto indent while pasting
function! AutoIndentPaste()
  " Don't apply on these filetypes
  if &filetype =~ 'markdown\|text|\snippets\|tex'
    return
  endif
  " Format and indent pasted text automatically. Also select pasted texts after
  nnoremap <buffer> p p=`]
  nnoremap <buffer> P P=`]
endfunction

" Toggle Locationlist
function! LocationlistToggle()
  for i in range(1, winnr('$'))
    let bnum = winbufnr(i)
    if getbufvar(bnum, '&buftype') == 'locationlist'
      lclose
      return
    endif
  endfor
  lopen
endfunction

" Toggle Quickfix
function! QuickfixToggle()
  for i in range(1, winnr('$'))
    let bnum = winbufnr(i)
    if getbufvar(bnum, '&buftype') == 'quickfix'
      cclose
      return
    endif
  endfor
  copen
endfunction

" When using `dd` in the quickfix list, remove the item from the quickfix list.
" Ref: https://stackoverflow.com/a/48817071/11850077
function! RemoveQFItem()
  let curqfidx = line('.') - 1
  let qfall = getqflist()
  call remove(qfall, curqfidx)
  call setqflist(qfall, 'r')
  execute curqfidx + 1 . "cfirst"
  :copen
endfunction
command! RemoveQFItem :call RemoveQFItem()

" Temporarily set 'lazyredraw' and execute {cmd}.
function! s:LazyCmd(cmd) abort
    let l:save_lazyredraw = &lazyredraw
    let l:err = v:null

    try
        set lazyredraw
        call execute(a:cmd)
    catch /.*/
        let l:err = v:exception
    finally
        if !l:save_lazyredraw
            set nolazyredraw
        endif
    endtry

    if l:err != v:null
        echohl ErrorMsg
        echom l:err
        echohl NONE
    endif
endfunction

" Temporarily set 'lazyredraw' and execute normal mode commands {cmd}.
function! s:LazyNorm(cmd) abort
    call s:LazyCmd("norm! " . a:cmd)
endfunction

" Always yank to plus registry by default. This is an alternative to setting
" clipboard=unnamedplus, which polutes system clipboard with every yank, delete,
" replace, etc.
" This function replaces the default yank operator
function! s:PlusYank(type = "") abort
    if a:type == ''
        let b:save_register = v:register
        set opfunc=<SID>PlusYank
        return 'g@'
    endif

    let l:reg = b:save_register == '"' ? '+' : b:save_register
    let l:save_sel = &selection
    let l:save_cb = &clipboard
    let l:save_visual_marks = [getpos("'<"), getpos("'>")]

    try
        set clipboard= selection=inclusive
        let commands = #{
                    \ line: "'[V']\"" . l:reg . "y",
                    \ char: "`[v`]\"" . l:reg . "y",
                    \ block: "`[\<c-v>`]\"" . l:reg . "y",
                    \ }
        silent exe 'keepjumps normal! ' .. get(commands, a:type, '')
    finally
        call setpos("'<", l:save_visual_marks[0])
        call setpos("'>", l:save_visual_marks[1])
        let &clipboard = l:save_cb
        let &selection = l:save_sel
    endtry
endfunction

" }}} HELPER FUNCTIONS




" SETTINGS TOGGLE MAPPINGS -------------------- {{{
function! SettingsToggleMappings()
  " General toggles
  nnoremap <silent> <LocalLeader>se :<C-u>call <SID>toggle_conceal()<CR>
  nnoremap <silent> <LocalLeader>ss :<C-u>call <SID>toggle_format_on_save()<CR>
  nnoremap <silent> <LocalLeader>sF :<C-u>call <SID>toggle_foldcolumn1()<CR>
  nnoremap <silent> <LocalLeader>sg :<C-u>call <SID>toggle_gutter()<CR>
  " nnoremap <silent> <LocalLeader>st :<C-u>call <SID>toggle_tabchar()<CR>
  nnoremap <silent> <LocalLeader>sv :<C-u>call <SID>toggle_virtualedit()<CR>
  nnoremap <silent> <LocalLeader>sW :<C-u>call <SID>toggle_text_wrapping()<CR>
  " Smart wrap toggle (breakindent and colorcolumn toggle as-well)
  nnoremap <LocalLeader>sw :execute('setlocal wrap! breakindent! colorcolumn=' .
        \ (&colorcolumn == '' ? &textwidth : ''))<CR>

  " UI toggles
  nnoremap <silent> <LocalLeader>sb :<C-u>call <SID>toggle_background()<CR>

  " Config toggles
  nnoremap <LocalLeader>sL :<C-u>call <SID>toggle_low_performance_mode()<CR>
endfunction
" }}} SETTINGS TOGGLE MAPPINGS

" ==================== Custom single purpose functions and mappings ==================== "

nnoremap <LocalLeader>sE <cmd>call EliteModeToggle()<CR>
" Append '.md' to clipboard register yanked file path and :edit from current directory
" nnoremap <Leader>;m :cd %:h<bar>execute "e " . expand("%:p:h") . '/' . getreg('+') . '.md'<bar>echo 'Opened ' . expand("%:p")<CR>

" Ref: https://stackoverflow.com/a/9407015/11850077
function! NextClosedFold(direction)
  let cmd = 'norm!z' . a:direction
  let view = winsaveview()
  let [l0, l, open] = [0, view.lnum, 1]
  while l != l0 && open
    exe cmd
    let [l0, l] = [l, line('.')]
    let open = foldclosed(l) < 0
  endwhile
  if open
    call winrestview(view)
  endif
endfunction

" Ref: https://vim.fandom.com/wiki/Navigate_to_the_next_open_fold
function! NextOpenFold(direction)
  if (a:direction == "j")
    normal zj
    let start = line('.')
    while foldclosed(start) != -1
      let start = start + 1
    endwhile
  else
    normal zk
    let start = line('.')
    while foldclosed(start) != -1
      let start = start - 1
    endwhile
  endif
  call cursor(start, 0)
endfunction

" Toggle conceallevel
function! s:toggle_conceal()
  if &conceallevel
    set conceallevel=0
    echom 'Conceallevel 0'
  else
    set conceallevel=3
    echom 'Conceallevel 3'
  end
endfunction

" Toggle foldcolumn
function! s:toggle_foldcolumn1()
  if &foldcolumn == 0
    set foldcolumn=1
    echom 'Foldcolumn 1'
  else
    set foldcolumn=0
    echom 'Foldcolumn 0'
  end
endfunction

" Toggle gutter
function! s:toggle_gutter()
  if &signcolumn == 'yes'
    set signcolumn=no
    echom 'Sign gutter deactivated'
  else
    set signcolumn=yes
    echom 'Sign gutter activated'
  endif
endfunction

" Toggle virtualedit mode
function! s:toggle_virtualedit()
  if &virtualedit == ""
    set virtualedit=all
    echom 'Virtualedit activated'
  else
    set virtualedit=""
    echom 'Virtualedit deactivated'
  endif
endfunction

" Toggle Tab Char
function! s:toggle_tabchar()
  if &lcs =~ 'tab:  '
    execute 'set lcs-=tab:\ \ '
    execute 'set lcs+=tab:\▏\ '
    echom "Tabchar set to '▏  '"
  elseif &lcs =~ 'tab:▏ '
    execute 'set lcs-=tab:\▏\ '
    execute 'set lcs+=tab:\ \ '
    echom 'Tabchar set to default'
  endif
endfunction

" Toggle Text wrapping
function! s:toggle_text_wrapping()
  if stridx(&formatoptions, 't') == -1
    execute 'set formatoptions+=t'
    echom 'Text wrapping activated'
  else
    execute 'set formatoptions-=t'
    echom 'Text wrapping deactivated'
  endif
endfunction

function! s:toggle_background()
  if ! exists('g:colors_name')
    echomsg 'No colorscheme set'
    return
  endif
  let l:scheme = g:colors_name

  if l:scheme =~# 'dark' || l:scheme =~# 'light'
    " Rotate between different theme backgrounds
    execute 'colorscheme' (l:scheme =~# 'dark'
          \ ? substitute(l:scheme, 'dark', 'light', '')
          \ : substitute(l:scheme, 'light', 'dark', ''))
  else
    execute 'set background='.(&background ==# 'dark' ? 'light' : 'dark')
    if ! exists('g:colors_name')
      execute 'colorscheme' l:scheme
      echomsg 'The colorscheme `'.l:scheme
            \ .'` doesn''t have background variants!'
    else
      echo 'Set colorscheme to '.&background.' mode'
    endif
  endif
endfunction

" Toggle format on save with noautocmd
function! s:toggle_format_on_save()
  if g:enable_format_on_save
    let g:enable_format_on_save = v:false
    echom 'Format on save deactivated'
  else
    let g:enable_format_on_save = v:true
    echom 'Format on save activated'
  endif
endfunction

function! SubstituteOddCharacters()
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

function! s:toggle_low_performance_mode()
  if get(g:, 'low_performance_mode', v:false)
    echom 'Low performance mode OFF. Restart nvim to take effect'
    let g:low_performance_mode=v:false
    call g:CacheToDataDir('low_performance_mode', v:false)
  else
    echom 'Low performance mode ON. Restart nvim to take effect'
    let g:low_performance_mode=v:true
    call g:CacheToDataDir('low_performance_mode', v:true)
  endif
endfunction

" Ref: https://vim.fandom.com/wiki/Selecting_your_pasted_text
" Select last pasted line(s)
function! SmartPaste()
  " Paste and indent pasted
  exe "norm! \<M-p>`[v`]="
  " Remove whitespace
  exe "norm! gv:WhitespaceErase\<CR>"
  " Substitute odd chars
  call SubstituteOddCharacters()
  " Reindent and format lines
  exe "norm! gv=gvgw"
  " Go to the end of the last selected texts
  exe "norm! 0`>"
endfunction

" DEPRECATED by vim-maximizer
" " Simple zoom toggle
" function! s:custom_zoom()
"   if exists('t:custom_zoomed')
"     unlet t:custom_zoomed
"     wincmd =
"   else
"     let t:custom_zoomed = { 'nr': bufnr('%') }
"     vertical resize
"     resize
"     normal! ze
"   endif
" endfunction

function! EliteModeToggle()
  if get(g:, 'elite_mode', 0) ==# 1
    " Enable lsp
    if exists(':LspStart')
      LspStart
    endif
    " Enable Copilot
    if exists(':Copilot')
      Copilot enable
    endif
    echom 'Elite mode off'
    let g:elite_mode=v:false
  else
    " Disable lsp
    if exists(':LspStop')
      LspStop
    endif
    " Disable Copilot
    if exists(':Copilot')
      Copilot disable
    endif
    echom 'Elite mode on'
    let g:elite_mode=v:true
  endif
endfunction

" ==================== Mappings Function Calls ==================== "

" Phase 1 calls (ExitMappings, ImprovedDefaultMappings, ExtendedBasicMappings,
" OperatorMappings) are now in lua/user/core/mappings_vim.lua
" Phase 1 + Phase 2 calls are now in lua/user/core/mappings_vim.lua
" (Phase 2: FilePathMappings, FileManagementMappings, WindowsManagementMappings,
"           UtilityMappings, CommandMappings)
" Phase 3 calls (YankPaste, EmacsLike, QuickFixLocationList, Register, Diff,
" Folds, Session, TextManipulation) are now in lua/user/core/mappings_vim.lua

call SettingsToggleMappings()

