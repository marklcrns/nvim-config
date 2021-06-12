" ==================== Mappings ==================== "

" Set leader and localleader keys
let g:mapleader="\<Space>"
let g:maplocalleader=';'

" Release keymappings prefixes, evict entirely for use of plug-ins.
nnoremap <Space>  <Nop>
xnoremap <Space>  <Nop>
nnoremap ,        <Nop>
xnoremap ,        <Nop>
nnoremap ;        <Nop>
xnoremap ;        <Nop>

" BASIC MAPPINGS -------------------- {{{
function! ExitMappings()
  " Quit without saving
  nnoremap <silent> <Leader>q :q!<CR>
  xnoremap <silent> <Leader>q <Esc>:q!<CR>
  " Quit all without saving
  nnoremap <silent> <Leader>Q :qa!<CR>
  xnoremap <silent> <Leader>Q <Esc>:qa!<CR>
  " Write/Save buffer
  nnoremap <silent> <leader>fs :w<CR>
  xnoremap <silent> <leader>fs <Esc>:w<CR>
  " Write/Save all buffer
  nnoremap <silent> <leader>fS :wa<CR>
  xnoremap <silent> <leader>fS <Esc>:wa<CR>
  " Save and quit
  nnoremap <silent> <leader>fq :wq<CR>
  xnoremap <silent> <leader>fq <Esc>:wq<CR>
  " Wipe buffer
  nnoremap <silent> <leader>fw :bw<CR>
  xnoremap <silent> <leader>fw :<Esc>bw<CR>
  " Save all and quit
  nnoremap <leader>fQ :confirm wqa!<CR>
  xnoremap <leader>fQ :<Esc>confirm wqa!<CR>
endfunction

function! ImprovedDefaultMappings()
  " Prevent x from overriding what's in the clipboard.
  noremap x "_x
  noremap X "_X
  " Prevent selecting and pasting from overwriting what you originally copied.
  xnoremap p pgvy
  " Re-select blocks after indenting in visual/select mode
  xnoremap < <gv
  xnoremap > >gv|
  " Keep cursor at the bottom of the visual selection after you yank it.
  vnoremap y ygv<Esc>
  " Fixes `[c` and `]c` not working
  nnoremap [c [c
  nnoremap ]c ]c
  " Scroll step sideways
  nnoremap zl z4l
  nnoremap zh z4h
  " Open file under the cursor in a vsplit
  nnoremap gf :vertical wincmd f<CR>
  " The plugin rhysd/accelerated-jk moves through display-lines in normal mode,
  " these mappings will move through display-lines in visual mode too.
  vnoremap j gj
  vnoremap k gk

  " DISABLE: Conflict with rhysd/accelerated-jk
  " " Makes Relative Number jumps work with text wrap
  " noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
  " noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
  " vnoremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
  " vnoremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')

  " Improve scroll, credits: https://github.com/Shougo
  noremap <expr> zz (winline() == (winheight(0)+1) / 2) ?
        \ 'zt' : (winline() == 1) ? 'zb' : 'zz'
  noremap <expr> <C-f> max([winheight(0) - 2, 1])
        \ ."\<C-d>".(line('w$') >= line('$') ? "L" : "M")
  noremap <expr> <C-b> max([winheight(0) - 2, 1])
        \ ."\<C-u>".(line('w0') <= 1 ? "H" : "M")
  noremap <expr> <C-e> (line("w$") >= line('$') ? "j" : "3\<C-e>")
  noremap <expr> <C-y> (line("w0") <= 1         ? "k" : "3\<C-y>")
  " Closing pop-up auto-completion before inserting new line in insert mode
  inoremap <expr> <M-o> (pumvisible() <bar><bar> &insertmode) ? '<C-e><C-o>o' : '<C-o>o'
  inoremap <expr> <M-O> (pumvisible() <bar><bar> &insertmode) ? '<C-e><C-O>O' : '<C-O>O'
endfunction

function! ExtendedBasicMappings()
  " Disables esc key on some modes to force new habit
  " Allow <Esc> to exit terminal-mode back to normal:
  tnoremap <Esc> <C-\><C-n>
  " Esc from insert, visual and command mode shortcuts (also moves cursor to the right)
  inoremap fd <Esc>`^
  inoremap kj <Esc>`^
  vnoremap fd <Esc>`<
  vnoremap df <Esc>`>
  cnoremap <C-[> <C-c>
  cnoremap <C-g> <C-c>
  " Exit from terminal-mode to normal
  tnoremap <Esc> <C-\><C-n>
  " Insert actual tab instead of spaces. Useful when `expandtab` is in use
  inoremap <S-Tab> <C-v><Tab>
  " Yank to end
  nnoremap Y y$
  " Easier line-wise movement
  nnoremap gh g^
  nnoremap gl g$
  " Jump entire buffers in jumplist
  nnoremap g<C-i> :<C-u>call JumpBuffer(-1)<CR>
  nnoremap g<C-o> :<C-u>call JumpBuffer(1)<CR>
  " Insert newline below
  inoremap <S-CR> <C-o>o
  " Resize tab windows after top/bottom window movement
  nnoremap <C-w>K <C-w>K<C-w>=
  nnoremap <C-w>J <C-w>J<C-w>=
  " Select last paste
  nnoremap <expr> gp '`['.strpart(getregtype(), 0, 1).'`]'
  " Increment/Decrement next searcheable number by one. Wraps at end of file.
  function! AddSubtract(char, back)
    let pattern = &nrformats =~ 'alpha' ? '[[:alpha:][:digit:]]' : '[[:digit:]]'
    call search(pattern, 'cw' . a:back)
    execute 'normal! ' . v:count1 . a:char
    silent! call repeat#set(":\<C-u>call AddSubtract('" .a:char. "', '" .a:back. "')\<CR>")
  endfunction
  nnoremap <silent> <M-a> :<C-u>call AddSubtract("\<C-a>", '')<CR>
  nnoremap <silent> <M-x> :<C-u>call AddSubtract("\<C-x>", '')<CR>
  " Increment/Decrement previous searcheable number by one. Wraps at start of file.
  nnoremap <silent> <M-S-a> :<C-u>call AddSubtract("\<C-a>", 'b')<CR>
  nnoremap <silent> <M-S-x> :<C-u>call AddSubtract("\<C-x>", 'b')<CR>

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

  vnoremap <silent> <M-c> :<C-u>call VShiftCharAscii(1)<CR>
  vnoremap <silent> <M-S-c> :<C-u>call VShiftCharAscii(-1)<CR>
  nnoremap <silent> <M-c> :<C-u>call ShiftCharAscii(matchstr(getline('.'), '\%' . col('.') . 'c.'), 1)<CR>
  nnoremap <silent> <M-S-c> :<C-u>call ShiftCharAscii(matchstr(getline('.'), '\%' . col('.') . 'c.'), -1)<CR>
endfunction
" }}} BASIC MAPPINGS

" OPERATOR MAPPINGS -------------------- {{{
function! OperatorMappings()
  " Inside next and last parenthesis
  onoremap in( :<C-u>normal! f(vi(<CR>
  onoremap il( :<C-u>normal! F)vi(<CR>
  " Around next and last parenthesis
  onoremap an( :<C-u>normal! f(va(<CR>
  onoremap al( :<C-u>normal! F)va(<CR>
endfunction
" }}} OPERATOR MAPPINGS

" FILE AND WINDOWS MAPPINGS -------------------- {{{
function! FilePathMappings()
  " Resources: https://vim.fandom.com/wiki/Get_the_name_of_the_current_file
  " Yank buffer's absolute path without file extension to '+' clipboard
  nnoremap <Leader>fye :let @+=expand("%:p:r")<bar>echo 'Yanked absolute file path without extension'<CR>
  " Yank buffer's relative path without file extension to '+' clipboard
  nnoremap <Leader>fyE :let @+=expand("%:r")<bar>echo 'Yanked relative file path without extension'<CR>
  " Yank buffer's absolute file path to '+' register
  nnoremap <Leader>fyp :let @+=expand("%:p")<bar>echo 'Yanked absolute file path'<CR>
  " Yank buffer's relative file path to '+' register
  nnoremap <Leader>fyP :let @+=expand("%:~:.")<bar>echo 'Yanked relative file path'<CR>
  " Yank buffer file name without extension to '+' register
  nnoremap <Leader>fyf :let @+=expand("%:t:r")<bar>echo 'Yanked file name without extension'<CR>
  " Yank buffer file name to '+' register
  nnoremap <Leader>fyF :let @+=expand("%:t")<bar>echo 'Yanked file name'<CR>
  " Yank buffer's absolut directory path to '+' register
  nnoremap <Leader>fyd :let @+=expand("%:p:h")<bar>echo 'Yanked absolute directory path'<CR>
  " Yank buffer's relative directory path to '+' register
  nnoremap <Leader>fyD :let @+=expand("%:p:h:t")<bar>echo 'Yanked relative directory path'<CR>
  " Yank buffer's file extension only to '+' clipboard
  nnoremap <Leader>fyx :let @+=expand("%:e")<bar>echo 'Yanked file extension'<CR>
  " :edit file path from clipboard register
  nnoremap <Leader>fyo :execute "e " . getreg('+')<bar>echo 'Opened ' . expand("%:p")<CR>
endfunction

function! FileManagementMappings()
  nnoremap <Leader>fD :echohl WarningMsg<bar> echom "File " . expand("%:p") . " deleting..."<bar>echohl None<bar>call delete(expand("%"))<bar>bdelete!<CR>
  " Set working directory to current file location for all windows
  nnoremap <Leader>frd :cd %:p:h<CR>:pwd<CR>
  " Set working directory to current file location only for the current window
  nnoremap <Leader>frl :lcd %:p:h<CR>:pwd<CR>
  " Open current file with xdg-open and disown
  nnoremap <silent><Leader>oo :!xdg-open "%:p" & disown<CR>
  " Open current file in google chrome and disown
  nnoremap <silent><Leader>og :!google-chrome "%:p" & disown<CR>
endfunction

function! WindowsManagementMappings()
  " Tab operation
  nnoremap <silent> <Leader>1 :<C-u>tabfirst<CR>
  nnoremap <silent> <Leader>5 :<C-u>tabprevious<CR>
  nnoremap <silent> <Leader>9 :<C-u>tablast<CR>
  nnoremap <silent> <Leader>tn :tabnew<cr>
  nnoremap <silent> <Leader>tq :tabclose<cr>
  nnoremap <silent> <Leader>te :tabedit
  nnoremap <silent> <Leader>tm :tabmove
  nnoremap <silent> [t :tabprevious<CR>
  nnoremap <silent> ]t :tabnext<CR>
  nnoremap <silent> ]T :tabmove+<CR>
  nnoremap <silent> [T :tabmove-<CR>

  " Move between buffers
  nnoremap <silent> ]b :bnext<CR>
  nnoremap <silent> [b :bprevious<CR>
  nnoremap <silent> ]B :blast<CR>
  nnoremap <silent> [B :bfirst<CR>

  " Open all buffers
  nnoremap <silent> <Leader>bah :sba<CR>
  nnoremap <silent> <Leader>bav :vert sba<CR>

  " Window-control prefix
  nnoremap  [Window]   <Nop>
  nmap      s [Window]

  " Splits
  nnoremap <silent> [Window]g  :<C-u>split<CR>
  nnoremap <silent> [Window]v  :<C-u>vsplit<CR>
  nnoremap <silent> [Window]q  :<C-u>close<CR>
  " nnoremap <silent> [Window]z  :<C-u>call <SID>custom_zoom()<CR>
  " Split current buffer, go to previous window and previous buffer
  nnoremap <silent> [Window]sv :split<CR>:wincmd p<CR>:e#<CR>
  nnoremap <silent> [Window]sg :vsplit<CR>:wincmd p<CR>:e#<CR>
  " Switch between splits
  nnoremap <silent> [Window]h <C-w>h
  nnoremap <silent> [Window]j <C-w>j
  nnoremap <silent> [Window]k <C-w>k
  nnoremap <silent> [Window]l <C-w>l
  nnoremap <silent> [Window]\ <C-w>p
  " Resize splits
  nnoremap <silent> [Window]K :resize -3<CR>
  nnoremap <silent> [Window]J :resize +3<CR>
  nnoremap <silent> [Window]H :vertical resize -3<CR>
  nnoremap <silent> [Window]L :vertical resize +3<CR>
  " Equalize splits
  nnoremap <silent> [Window]= :tabdo wincmd =<CR>


  " Replace arrow keys for resizing
  nnoremap <Up>      :resize -2<CR>
  nnoremap <Down>    :resize +2<CR>
  nnoremap <Left>    :vertical resize -2<CR>
  nnoremap <Right>   :vertical resize +2<CR>
endfunction
" }}} FILE AND WINDOWS MAPPINGS

" UTILITIES MAPPINGS -------------------- {{{
function! UtilityMappings()
  " Select last inserted characters.
  inoremap <M-v> <ESC>v`[
  " Use backspace key for matching pairs
  nmap <BS> %
  xmap <BS> %
  " Drag current line(s) vertically and auto-indent
  nnoremap <Leader>J :m+<CR>
  nnoremap <Leader>K :m-2<CR>
  vnoremap J :m'>+<CR>gv=gv
  vnoremap K :m'<-2<CR>gv=gv
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
  nnoremap <Leader>fg :call VimgrepWrapper("")<Left><Left>
  nnoremap <Leader>gD :GitOpenDirty<CR>
  " Termdebug
  packadd! termdebug
  nnoremap <Leader>dA :<C-u>call feedkeys(':Arguments<Space>','t')<CR>
  nnoremap <Leader>dd :<C-u>call feedkeys(':Termdebug<Space>','t')<CR>
  nnoremap <Leader>db :<C-u>Break<CR>
  nnoremap <Leader>dB :<C-u>Clear<CR>
  nnoremap <Leader>de :execute "Evaluate " . expand('<cword>')<CR>
  vnoremap <Leader>de :Evaluate<CR>
  nnoremap <Leader>dh :<C-u>Continue<CR>
  nnoremap <Leader>dl :<C-u>Step<CR>
  nnoremap <Leader>dr :<C-u>call feedkeys(':Run<Space>','t')<CR>
  nnoremap <Leader>dk :<C-u>Finish<CR>
  nnoremap <Leader>dx :<C-u>Stop<CR>
  if has('nvim')
    nnoremap <Leader>dj :<C-u>Over<CR>
  else
    nnoremap <Leader>dj :<C-u>Next<CR>
  endif
  nnoremap <Leader>da :<C-u>Asm<CR>
  nnoremap <Leader>dg :<C-u>Gdb<CR>
  nnoremap <Leader>dp :<C-u>Program<CR>
  nnoremap <Leader>df :<C-u>Source<CR>
endfunction

function! CommandMappings()
  " Commandline basic movements
  "cnoremap w!! w !sudo tee % >/dev/null
  cnoremap <C-p> <Up>
  cnoremap <C-b> <Left>
  cnoremap <C-f> <Right>
  cnoremap <C-a> <Home>
  cnoremap <C-e> <End>
  cnoremap <C-d> <Del>
  cnoremap <C-h> <BS>
  " print insert buffer file directory path
  cnoremap <C-t> <C-R>=expand("%:p:h") . "/" <CR>
  " Easy wildcharm navigation
  cnoremap <expr><C-j> pumvisible() ? "\<C-n>" : nr2char(&wildcharm)
  cnoremap <expr><C-k> pumvisible() ? "\<C-p>" : nr2char(&wildcharm)
  cnoremap <expr><Tab> pumvisible() ? "\<C-y>" . nr2char(&wildcharm) : nr2char(&wildcharm)
endfunction

function! YankPasteMappings()
  " Yank and paste line under cursor to and from "x register
  " nnoremap <C-y> "xyy"xp$
  inoremap <C-y> <Esc>"xyy"xp`.A
  " Duplicate current line then enter line substitution. DEPRECATED by vim-abolish
  " inoremap <C-y> <ESC>yypV:s//g<Left><Left>
  " Auto indent while pasting
  function! AutoIndentPaste()
    " Don't apply on these filetypes
    if &filetype =~ 'markdown\|vimwiki\|text|\snippets\|tex'
      return
    endif
    " Format and indent pasted text automatically. Also select pasted texts after
    nnoremap <buffer> p p=`]
    nnoremap <buffer> P P=`]
  endfunction
  autocmd BufWritePre * call AutoIndentPaste()
endfunction

function! EmacsLikeMappings()
  inoremap <C-h> <BS>
  inoremap <C-d> <Del>
  inoremap <C-a> <Home>
  inoremap <expr><C-e> pumvisible() ? "\<C-e>" : "\<End>"
  " Cursor navigation
  inoremap <C-b> <Left>
  inoremap <C-f> <Right>
  " move between sentences
  inoremap <M-a> <C-[>(i
  inoremap <M-e> <C-[>)i
endfunction

function! QuickFixLocationListMappings()
  " Move through the loclist
  nnoremap <silent> [l :lprevious<CR>
  nnoremap <silent> ]l :lnext<CR>
  nnoremap <silent> [L :lfirst<CR>
  nnoremap <silent> ]L :llast<CR>
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
  nnoremap <silent> <LocalLeader>ol :call LocationlistToggle()<CR>
  " Move through the quickfix list
  nnoremap <silent> [q :cprevious<CR>
  nnoremap <silent> ]q :cnext<CR>
  nnoremap <silent> [Q :cfirst<CR>
  nnoremap <silent> ]Q :clast<CR>
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
  nnoremap <silent> <LocalLeader>oq :call QuickfixToggle()<CR>
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
  :command! RemoveQFItem :call RemoveQFItem()
  " Use map <buffer> to only map dd in the quickfix window. Requires +localmap
  autocmd FileType qf map <buffer> dd :RemoveQFItem<cr>
endfunction

function! RegisterMappings()
  " Cycle through vim register +abjkx.
  " Register `+` as the system clipboard and `x` as temp holder
  " `j` cycles forward, `k` cycles backward
  nnoremap <Leader>rej :let @x=@k \| let @k=@j \| let @j=@b \| let @b=@a \| let @a=@+ \| let @+=@x \| reg +abjk<CR>
  nnoremap <Leader>rek :let @x=@+ \| let @+=@a \| let @a=@b \| let @b=@j \| let @j=@k \| let @k=@x \| reg +abjk<CR>
  " Cycle through registers then paste register `+`
  nnoremap <Leader>reJ :let @x=@k \| let @k=@j \| let @j=@b \| let @b=@a \| let @a=@+ \| let @+=@x \| reg +abjk<CR>p
  nnoremap <Leader>reK :let @x=@+ \| let @+=@a \| let @a=@b \| let @b=@j \| let @j=@k \| let @k=@x \| reg +abjk<CR>p
  vnoremap <Leader>reJ :let @x=@k \| let @k=@j \| let @j=@b \| let @b=@a \| let @a=@+ \| let @+=@x \| reg +abjk<CR>p
  vnoremap <Leader>reK :let @x=@+ \| let @+=@a \| let @a=@b \| let @b=@j \| let @j=@k \| let @k=@x \| reg +abjk<CR>p
  " Copy selected then cycle through registers
  vnoremap <Leader>rej y<ESC>:let @x=@k \| let @k=@j \| let @j=@b \| let @b=@a \| let @a=@+ \| let @+=@x \| reg +abjk<CR>
  vnoremap <Leader>rek y<ESC>:let @x=@+ \| let @+=@a \| let @a=@b \| let @b=@j \| let @j=@k \| let @k=@x \| reg +abjk<CR>
  " Display register +abjk
  nnoremap <Leader>reg :reg +abjk<CR>
endfunction

function! DiffMappings()
  " Diff split with a file (auto wildcharm trigger)
  if !&wildcharm | set wildcharm=<C-z> | endif
  exe 'nnoremap <Leader>idv :vert diffsplit '.expand("%:p:h").'/'.nr2char(&wildcharm)
  exe 'nnoremap <Leader>idh :diffsplit '.expand("%:p:h").'/'.nr2char(&wildcharm)
  exe 'nnoremap <Leader>idV :vert diffsplit $HOME/'.nr2char(&wildcharm)
  exe 'nnoremap <Leader>idH :diffsplit $HOME/'.nr2char(&wildcharm)

  nmap <silent> <Leader>idd :DiffOrig<CR>

  function! PrintMergeDiffMappings()
    " Only display once if g:custom_diff_enable = 0
    if get(g:, 'custom_diff_enable', 0) ==# 1
      return
    endif

    " Git mappings for mergetools (also works for vimdiff, i.e. LOCAL for
    " original code, and REMOTE for new changes)
    "
    " Add the following to .gitconfig, then run `git mergetool nvimdiff <MERGE_CONFLICT_FILE>`
    " [merge]
    "   tool = nvimdiff
    " [mergetool "nvimdiff"]
    "   cmd = nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'
    " [mergetool]
    "   prompt = true

    " Diff mappings only when in diff buffer
    nnoremap <expr> dob &diff ? ':diffget BASE<CR>'   : ''
    nnoremap <expr> dol &diff ? ':diffget LOCAL<CR>'  : ''
    nnoremap <expr> dor &diff ? ':diffget REMOTE<CR>' : ''
    " Quit nvim with an error code. Useful when aborting git mergetool or git commit
    nnoremap <expr> cq  &diff ? ':cquit<CR>'          : ''

    echom " "
    echom "dob :diffget BASE"
    echom "dol :diffget LOCAL"
    echom "dor :diffget REMOTE"
    echom "cq  :cquit"
    echom "]c  Next conflict"
    echom "[c  Previous conflict"

    " Only shows the first time this function is called
    if !exists("g:custom_diff_enable")
      echohl WildMenu | echom "To view these again, type :messages or :call PrintMergeDiffMappings()" | echohl NONE
    endif

    let g:custom_diff_enable = 1
  endfunction

  " Display diff mappings on diff mode
  augroup user_diffmode
    autocmd!
    autocmd OptionSet diff if v:option_old == 0 && v:option_new != 0 | call PrintMergeDiffMappings() | else | let g:custom_diff_enable = 0 | endif
  augroup END
endfunction

function! FoldsMappings()
  " Toggle fold
  nnoremap <Leader>z za
  " Focus the current fold by closing all others
  nnoremap <Leader>Z zMzvzt
  " Toggle fold all
  nnoremap <expr> zm &foldlevel ? 'zM' :'zR'
  " Jumping to next closed fold
  nnoremap <silent> zj :<C-u>call <SID>next_closed_fold('j')<cr>
  nnoremap <silent> zk :<C-u>call <SID>next_closed_fold('k')<cr>
  nnoremap <silent> zn :<C-u>call <SID>next_open_fold('j')<cr>
  nnoremap <silent> zp :<C-u>call <SID>next_open_fold('k')<cr>
endfunction

function! SessionMappings()
  nnoremap <Leader>ss :<C-u>SessionSave<Space>
  nnoremap <Leader>sl :<C-u>call feedkeys(':SessionLoad<Space><Tab>','t')<CR>
  nnoremap <Leader>sD :<C-u>call feedkeys(':SessionDelete<Space><Tab>','t')<CR>
  nnoremap <Leader>sL :<C-u>SessionList<CR>
  nnoremap <Leader>sq :<C-u>SessionClose<CR>
  nnoremap <Leader>sd :<C-u>SessionDetach<CR>
endfunction
" }}} UTILITIES MAPPINGS

" TEXT MANIPULATION MAPPINGS -------------------- {{{
function! TextManipulationMappings()
  " whitespace.vim
  nnoremap <silent><Leader>r<Space> :<C-u>WhitespaceErase<CR>
  vnoremap <silent><Leader>r<Space> :WhitespaceErase<CR>
  " Wrap paragraph to textwidth
  nnoremap <Leader>rw gwap
  xnoremap <Leader>rw gw
  " Duplicate paragraph
  nnoremap <leader>rp yap<S-}>p
  " Duplicate selected line
  " Ref: https://stackoverflow.com/a/3806683/11850077
  vnoremap <Leader>rp y`]p
  " Change current word in a repeatable manner (repeatable with ".")
  nnoremap <leader>rn *``cgn
  nnoremap <leader>rN *``cgN
  " Change selected word in a repeatable manner
  vnoremap <expr> <leader>rn "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgn"
  vnoremap <expr> <leader>rN "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>" . "``cgN"
  " Search and replace whole buffer
  nnoremap <Leader>rr :%s//gc<Left><Left><Left>
  " Search and replace current line only
  nnoremap <Leader>rR :s//gc<Left><Left><Left>
  " Search and replace within visually selected only
  xnoremap <Leader>rr :s//gc<Left><Left><Left>
  " Returns visually selected text
  function! s:get_selection(cmdtype)
    let temp = @s
    normal! gv"sy
    let @/ = substitute(escape(@s, '\'.a:cmdtype), '\n', '\\n', 'g')
    let @s = temp
  endfunction
  " Search and replace last selected with confirmation
  nnoremap <Leader>rF :<C-u>call <SID>get_selection('/')<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>
  xnoremap <Leader>rF :<C-u>call <SID>get_selection('/')<CR>:%s/\V<C-R>=@/<CR>//gc<Left><Left><Left>
  " To enumerate lines with macro: https://stackoverflow.com/a/32053439/11850077
  " To enumerate lines with few commands: https://stackoverflow.com/a/48408001/11850077
  " Ref: https://vi.stackexchange.com/a/690
  nnoremap <Leader>rL :%s/^/\=line('.').". "<CR>
  " Ref: https://stackoverflow.com/a/51291652
  vnoremap <silent> <Leader>rl :<C-U>let i=1 \| '<,'>g/^/s//\=i.'. '/ \| let i=i+1 \| nohl<CR>
  " Fix indentation of whole buffer
  nnoremap <Leader>ri gg=G<C-o>
  " Ref: https://stackoverflow.com/a/17440797/11850077
  " Capitaliz each word of the selected
  vnoremap <Leader>rC :s/\<./\u&/g \| nohl<CR>
  " Capitalize each word of current entire file
  nnoremap <Leader>rC :%s/\<./\u&/g<CR>:nohl<CR>
  " Lowercase each word of the selected
  vnoremap <Leader>rc :s/\<./\l&/g<CR>:nohl<CR>
  " Lowercase each word of current entire file
  nnoremap <Leader>rc :%s/\<./\l&/g<CR>:nohl<CR>
  " Yank everything from current file
  nnoremap <Leader>rya ggVGy:echom "Yanked all file contents!"<CR>
  " Replace all with yanked texts
  nnoremap <Leader>ryp ggVGP:echom "Replaced all with yanked texts!"<CR>
  " Jumps to previously misspelled word and fixes it with the first in the suggestion
  " Update: also echo changes and line and col number
  " Ref: https://castle.Dev/post/lecture-notes-1/
  inoremap <C-s> <Esc>:set spell<bar>norm i<C-g>u<Esc>[s"syiW1z="tyiW:let @l=line('.')<bar>let @c=virtcol('.')<CR>``a<C-g>u<Esc>:set nospell<bar>:echo getreg('l') . ":" . getreg('c') . " spell fixed (" . getreg('s') . " -> " . getreg('t') . ")"<CR>la
endfunction
" }}} TEXT MANIPULATION MAPPINGS

" SETTINGS TOGGLE MAPPINGS -------------------- {{{
function! SettingsToggleMappings()
  nmap <silent> <LocalLeader>sll :<C-u>call <SID>toggle_cursorline()<CR>
  nmap <silent> <LocalLeader>slc :<C-u>call <SID>toggle_cursorcolumn()<CR>
  nmap <silent> <LocalLeader>slx :<C-u>call <SID>toggle_crosshair()<CR>
  nmap <silent> <LocalLeader>sb :<C-u>call <SID>toggle_background()<CR>
  nmap <silent> <LocalLeader>se :<C-u>call <SID>toggle_conceal2()<CR>
  nmap <silent> <LocalLeader>sg :<C-u>call <SID>toggle_gutter()<CR>
  nmap <silent> <LocalLeader>st :<C-u>call <SID>toggle_tabchar()<CR>
  nmap <silent> <LocalLeader>sv :<C-u>call <SID>toggle_virtualedit()<CR>
  nmap <silent> <LocalLeader>ss :set spell!<CR>
  " Smart wrap toggle (breakindent and colorcolumn toggle as-well)
  nmap <LocalLeader>sw :execute('setlocal wrap! breakindent! colorcolumn=' .
        \ (&colorcolumn == '' ? &textwidth : ''))<CR>
endfunction
" }}} SETTINGS TOGGLE MAPPINGS

" ==================== Custom single purpose functions and mappings ==================== "

" Append '.md' to clipboard register yanked file path and :edit from current directory
nnoremap <Leader>;m :cd %:h<bar>execute "e " . expand("%:p:h") . '/' . getreg('+') . '.md'<bar>echo 'Opened ' . expand("%:p")<CR>


" Ref: https://stackoverflow.com/a/9407015/11850077
function! s:next_closed_fold(direction)
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
function! s:next_open_fold(direction)
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

" Toggle cursorline
function! s:toggle_cursorline()
  if get(g:, 'custom_cursorline_enable', 1)
    set nocursorline
    let g:custom_cursorline_enable = 0
    echom 'Cursorline deactivated'
  else
    set cursorline
    let g:custom_cursorline_enable = 1
    echom 'Cursorline activated'
  endif
endfunction

" Toggle cursorcolumn
function! s:toggle_cursorcolumn()
  if get(g:, 'custom_cursorcolumn_enable', 0)
    set nocursorcolumn
    let g:custom_cursorcolumn_enable = 0
    echom 'Cursorcolumn deactivated'
  else
    set cursorcolumn
    let g:custom_cursorcolumn_enable = 1
    echom 'Cursorcolumn activated'
  endif
endfunction

" Toggle cursorline and cursorcolumn
function! s:toggle_crosshair()
  if (&cursorline || &cursorcolumn)
    set nocursorline nocursorcolumn
    let g:custom_cursorline_enable = 0
    let g:custom_cursorcolumn_enable = 0
    echom 'Crosshair activated'
  else
    set cursorline cursorcolumn
    let g:custom_cursorline_enable = 1
    let g:custom_cursorcolumn_enable = 1
    echom 'Crosshair deactivated'
  endif
endfunction

" Toggle conceallevel
function! s:toggle_conceal2()
  if &conceallevel
    set conceallevel=0
    echom 'Conceallevel 0'
  else
    set conceallevel=2
    echom 'Conceallevel 2'
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
    echom 'Tabchar set'
  elseif &lcs =~ 'tab:▏ '
    execute 'set lcs-=tab:\▏\ '
    execute 'set lcs+=tab:\ \ '
    echom 'Tabchar default'
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

" ==================== Mappings Function Calls ==================== "

" Basic Mappings
call ExitMappings()
call ImprovedDefaultMappings()
call ExtendedBasicMappings()
" Operator Mappings
call OperatorMappings()
" File and Windows Mappings
call FilePathMappings()
call FileManagementMappings()
call WindowsManagementMappings()
" Utilities Mappings
call UtilityMappings()
call CommandMappings()
call YankPasteMappings()
call EmacsLikeMappings()
call QuickFixLocationListMappings()
call RegisterMappings()
call DiffMappings()
call FoldsMappings()
call SessionMappings()
" Text Manipulation Mappings
call TextManipulationMappings()
" Settings Toggle Mappings
call SettingsToggleMappings()

