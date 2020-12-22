" ==================== Mappings ==================== "

" BASIC MAPPINGS -------------------- {{{
function! ExitMappings()
  " Quit without saving
  nnoremap <silent> <Leader>q :silent q!<CR>
  xnoremap <silent> <Leader>q <Esc>:silent q!<CR>
  " Quit all without saving
  nnoremap <silent> <Leader>Q :silent qa!<CR>
  xnoremap <silent> <Leader>Q <Esc>:silent qa!<CR>
  " Write/Save buffer
  nnoremap <silent> <leader>fs :silent w<bar>echo "buffer saved!"<CR>
  xnoremap <silent> <leader>fs <Esc>:silent w<bar>echo "buffer saved!"<<CR>
  " Write/Save all buffer
  nnoremap <silent> <leader>fS :silent wa<bar>echo "all buffer saved!"<CR>
  xnoremap <silent> <leader>fS <Esc>:silent wa<bar>echo "all buffer saved!"<CR>
  " Save and quit
  nnoremap <silent> <leader>fq :silent wq!<CR>
  xnoremap <silent> <leader>fq <Esc>:silent wq!<CR>
  " Wipe buffer
  nnoremap <silent> <leader>fw :bw<bar>echo "buffer wiped!"<CR>
  xnoremap <silent> <leader>fw :<Esc>bw<bar>echo "buffer wiped!"<CR>
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
  " Makes Relative Number jumps work with text wrap
  noremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
  noremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
  vnoremap <silent> <expr> j (v:count == 0 ? 'gj' : 'j')
  vnoremap <silent> <expr> k (v:count == 0 ? 'gk' : 'k')
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
  " Remaps macro record key since q has been remapped
  nnoremap Q q
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
  " Ref: https://stackoverflow.com/a/10102604
  function! CleanEmptyBuffers()
    let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0 && !getbufvar(v:val, "&mod")')
    if !empty(buffers)
      " Wipe all empty buffers
      exe 'bw ' . join(buffers, ' ')
    endif
  endfunction
  " Smartly close buffers mindful of splits and read-only buffers
  " Ref: https://stackoverflow.com/a/29236158
  function! SmartBufClose()
    let curBuf = bufnr('%')
    let curBufName = bufname('%')
    let curBufCount = len(filter(range(1, bufnr('$')), 'buflisted(v:val)'))
    let curTab = tabpagenr()
    call CleanEmptyBuffers()
    " Smart quit
    if &filetype ==# 'gitcommit'
      silent execute 'q!'
      return
    elseif !&modifiable
      silent execute 'bw!'
      return
    elseif ((curBufCount ==# 1 && curBufName ==# '') || &buftype ==# 'nofile') " Quit when only buffer and empty
      silent execute 'q!'
      return
    elseif (curBufName ==# '' || &readonly || &buftype ==# 'terminal') " Wipe readonly buffer, terminal, and empty to remove from jump stack
      silent execute 'bw!'
      return
    endif
    " Go to next buffer (most likely empty to be deleted)
    execute 'bnext'
    " If in the same buffer as the last, create empty buffer
    if curBuf ==# bufnr('%')
      " Check for splits
      if winnr('$') !=# 1
        execute "close"
        return
      else
        " create new buffer empty if no splits
        execute 'enew'
      endif
    else
      " Go to buffer prior to the deleted one
      execute 'bprev'
      execute 'bprev'
    endif
    " Loop through tabs
    for i in range(tabpagenr('$'))
      " Go to tab (is there a way with inactive tabs?)
      execute 'tabnext ' . (i + 1)
      " Store active window nr to restore later
      let curWin = winnr()
      " Loop through windows pointing to buffer
      let winnr = bufwinnr(curBuf)
      while (winnr >= 0)
        " Go to window and switch to next buffer
        execute winnr . 'wincmd w | bnext'
        " Restore active window
        execute curWin . 'wincmd w'
        let winnr = bufwinnr(curBuf)
      endwhile
      echo 'Exited ' . curBufName
    endfor
    " Close buffer, restore active tab
    silent execute 'silent! bdelete' . curBuf
    silent execute 'silent! tabnext ' . curTab
    " if only one buffer remains, and a split/s exists close all extra splits
    " Ref: https://superuser.com/questions/345520/vim-number-of-total-buffers
    if len(getbufinfo({'buflisted':1})) ==# 1 && winnr('$') !=# 1
      for i in range(winnr('$') - 0)
        execute "silent! close"
      endfor
    endif
  endfunction
  noremap <silent> q :call SmartBufClose()<cr>

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

  " Window-control prefix
  nnoremap  [Window]   <Nop>
  nmap      s [Window]

  " Background dark/light toggle and contrasts
  nmap <silent> [Window]H :<C-u>call <SID>toggle_background()<CR>
  nmap <silent> [Window]- :<c-u>call <SID>toggle_contrast(-v:count1)<cr>
  nmap <silent> [Window]= :<c-u>call <SID>toggle_contrast(+v:count1)<cr>

  " Splits
  nnoremap <silent> [Window]v  :<C-u>split<CR>
  nnoremap <silent> [Window]g  :<C-u>vsplit<CR>
  " Split current buffer, go to previous window and previous buffer
  nnoremap <silent> [Window]sv :split<CR>:wincmd p<CR>:e#<CR>
  nnoremap <silent> [Window]sg :vsplit<CR>:wincmd p<CR>:e#<CR>
  " Resize splits
  nnoremap [Window]k :resize -3<CR>
  nnoremap [Window]j :resize +3<CR>
  nnoremap [Window]h :vertical resize -3<CR>
  nnoremap [Window]l :vertical resize +3<CR>
  nnoremap [Window]q :close<CR>
  nnoremap <Up>      :resize -1<CR>
  nnoremap <Down>    :resize +1<CR>
  nnoremap <Left>    :vertical resize -1<CR>
  nnoremap <Right>   :vertical resize +1<CR>
  " Switch between splits
  nnoremap <M-h> <C-w>h
  nnoremap <M-l> <C-w>l
  nnoremap <M-j> <C-w>j
  nnoremap <M-k> <C-w>k

  " Deletes buffer but keeps the split
  " Ref: https://stackoverflow.com/a/19619038/11850077
  noremap [Window]d :b#<bar>bd#<CR>
  nnoremap <silent> [Window]z  :<C-u>call <SID>custom_zoom()<CR>
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
  cnoremap <expr><C-j> pumvisible() ? "\<C-n>" : nr4char(&wildcharm)
  cnoremap <expr><C-k> pumvisible() ? "\<C-p>" : nr3char(&wildcharm)
  cnoremap <expr><Tab> pumvisible() ? "\<C-e>".nr2char(&wildcharm) : nr2char(&wildcharm)
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
  " Insert keymap like emacs (Adjusted for new <Esc>`^ remapping above)
  " delete word before cursor (prioritize words over punctualtions and
  " delimiters)
  " imap <C-w> <C-[>bcaw
  " no longer needed. Ref: https://vim.fandom.com/wiki/Recover_from_accidental_Ctrl-U
  " imap <C-u> <C-G>u<C-U>
  inoremap <C-h> <BS>
  inoremap <C-d> <Del>
  inoremap <C-k> <C-[>Da
  inoremap <C-a> <Home>
  inoremap <expr><C-e> pumvisible() ? "\<C-e>" : "\<End>"
  " Cursor navigation
  inoremap <C-b> <Left>
  inoremap <C-f> <Right>
  inoremap <expr><C-n> pumvisible() ? "\<C-n>" : "\<Down>"
  inoremap <expr><C-p> pumvisible() ? "\<C-p>" : "\<Up>"
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
  nnoremap <LocalLeader>l :call LocationlistToggle()<CR>
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
  nnoremap <LocalLeader>q :call QuickfixToggle()<CR>
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
  " Git mappings for mergetools or diff mode
  " Add the following to .gitconfig, then run `git mergetool nvimdiff <MERGE_CONFLICT_FILE>`
  " [merge]
  "   tool = nvimdiff
  " [mergetool "nvimdiff"]
  "   cmd = nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'
  " [mergetool]
  "   prompt = true
  nnoremap <expr> dob &diff ? ':diffget BASE<CR>'   : ''
  nnoremap <expr> dob &diff ? ':diffget BASE<CR>'   : ''
  nnoremap <expr> dol &diff ? ':diffget LOCAL<CR>'  : ''
  nnoremap <expr> dor &diff ? ':diffget REMOTE<CR>' : ''
  " Quit nvim with an error code. Useful when aborting git mergetool or git commit
  nnoremap <expr> cq  &diff ? ':cquit<CR>'          : ''
  function! PrintMergeDiffMappings()
    echom "dob :diffget BASE"
    echom "dol :diffget LOCAL"
    echom "dor :diffget REMOTE"
    echom "cq  :cquit"
    echom "]c  Next conflict"
    echom "[c  Previous conflict"
    echom " "
    echom "To view these again, type :messages or :call PrintMergeDiffMappings()"
  endfunction

  nmap <silent> <Leader>idd :DiffOrig<CR>
endfunction

function! FoldsMappings()
  " Toggle fold
  nnoremap <Leader><CR> za
  " Focus the current fold by closing all others
  nnoremap <Leader><Leader><CR> zMzvzt
  " Toggle fold all
  nnoremap <expr> zm &foldlevel ? 'zM' :'zR'
  " Jumping to next closed fold
  " Ref: https://stackoverflow.com/a/9407015/11850077
  function! NextClosedFold(dir)
    let cmd = 'norm!z' . a:dir
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
  nnoremap <silent> <Leader>zj :call NextClosedFold('j')<cr>
  nnoremap <silent> <Leader>zk :call NextClosedFold('k')<cr>
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
  nnoremap <Leader>rya ggVGy<C-o>:echom "Yanked all file contents!"<CR>
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
  if &cursorline
    let g:activate_cursorline = 1
  else
    let g:activate_cursorline = 0
  endif
  if &cursorcolumn
    let g:activate_cursorcolumn = 1
  else
    let g:activate_cursorcolumn = 0
  endif
  " Toggle cursorline
  function! ToggleCursorline()
    if g:activate_cursorline == 1
      set nocursorline
      let g:activate_cursorline = 0
      echom 'Cursorline deactivated'
    else
      set cursorline
      let g:activate_cursorline = 1
      echom 'Cursorline activated'
    endif
  endfunction
  nmap <silent> <LocalLeader>sll :<C-u>call ToggleCursorline()<CR>
  " Toggle cursorcolumn
  function! ToggleCursorcolumn()
    if g:activate_cursorcolumn == 1
      set nocursorcolumn
      let g:activate_cursorcolumn = 0
      echom 'Cursorcolumn deactivated'
    else
      set cursorcolumn
      let g:activate_cursorcolumn = 1
      echom 'Cursorcolumn activated'
    endif
  endfunction
  nmap <silent> <LocalLeader>slc :<C-u>call ToggleCursorcolumn()<CR>
  " Toggle cursorline and cursorcolumn
  function! ToggleCrosshair()
    if (&cursorline || &cursorcolumn)
      set nocursorline nocursorcolumn
      let g:activate_cursorline = 0
      let g:activate_cursorcolumn = 0
    else
      set cursorline cursorcolumn
      let g:activate_cursorline = 1
      let g:activate_cursorcolumn = 1
    endif
  endfunction
  nmap <silent> <LocalLeader>slx :<C-u>call ToggleCrosshair()<CR>
  " Toggle conceallevel
  function! ToggleConcealLevel()
    if &conceallevel
      set conceallevel=0
    else
      set conceallevel=2
    end
  endfunction
  nmap <LocalLeader>se :call ToggleConcealLevel()<CR>
  " Toggle gutter
  function! ToggleGutter()
    if &signcolumn == 'yes'
      set signcolumn=no
      echom 'Sign gutter deactivated'
    else
      set signcolumn=yes
      echom 'Sign gutter activated'
    endif
  endfunction
  nmap <silent> <LocalLeader>sg :call ToggleGutter()<CR>
  " Toggle virtualedit mode
  function! ToggleVirtualedit()
    if &virtualedit == ''
      set virtualedit=all
    else
      set virtualedit=""
    endif
  endfunction
  nmap <LocalLeader>sv :<C-u>call ToggleVirtualedit()<CR>
  " Toggle spell check
  nmap <LocalLeader>ss :set spell!<CR>
  " Smart wrap toggle (breakindent and colorcolumn toggle as-well)
  nmap <LocalLeader>sw :execute('setlocal wrap! breakindent! colorcolumn=' .
        \ (&colorcolumn == '' ? &textwidth : ''))<CR>
endfunction
" }}} SETTINGS TOGGLE MAPPINGS

" MISC MAPPINGS -------------------- {{{
" Compile java in ./bin directory. NOTE: ./bin must exist
" Ref: https://stackoverflow.com/a/24708245
function! JavaMappings()
  " Compile and run current java file in next tmux pane
  function! JavaCompileRunVimux()
    exe '!javac -Xlint %'
    exe 'VimuxInterruptRunner'
    call VimuxRunCommand("clear; time java -cp " . expand("%:p:h") . " " . expand("%:t:r"))
  endfunction
  " Autocompile Java and run in another tmux pand
  autocmd FileType java nnoremap <buffer><silent><Leader>ljj :call JavaCompileRunVimux()<CR>
  " Compile current java file
  autocmd FileType java nnoremap <buffer><silent><Leader>ljc :!javac -Xlint %<CR>
  autocmd FileType java nnoremap <buffer><silent><Leader>ljC :!javac -Xlint *.java<CR>
  " Save, complie, and run java file in current buffer <C-c> to exit program
  autocmd FileType java nnoremap <buffer><silent><Leader>ljr :w<CR>:terminal javac -Xlint % && time java -cp %:p:h %:t:r<CR>
  " F9 to compile, F10/F11 to cycle through errors.
  " Ref: https://stackoverflow.com/a/14727153
  autocmd Filetype java set makeprg=javac\ -Xlint\ %
  set errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
  map <F9> :make<Return>:copen<Return>
  map <F10> :cprevious<Return>
  map <F11> :cnext<Return>
endfunction
function! GitMappings()
  nnoremap <Leader>gP :<C-u>terminal git push<CR>
endfunction
" }}} MISC MAPPINGS

" ==================== Custom single purpose functions and mappings ==================== "

" Append '.md' to clipboard register yanked file path and :edit from current directory
nnoremap <Leader>;wm :cd %:h<bar>execute "e " . expand("%:p:h") . '/' . getreg('+') . '.md'<bar>echo 'Opened ' . expand("%:p")<CR>

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

function! s:toggle_contrast(delta)
  let l:scheme = ''
  if g:colors_name =~# 'solarized8'
    let l:schemes = map(['_low', '_flat', '', '_high'],
          \ '"solarized8_".(&background).v:val')
    let l:contrast = ((a:delta + index(l:schemes, g:colors_name)) % 4 + 4) % 4
    let l:scheme = l:schemes[l:contrast]
  endif
  if l:scheme !=# ''
    execute 'colorscheme' l:scheme
  endif
endfunction

function! s:window_empty_buffer()
  let l:current = bufnr('%')
  if ! getbufvar(l:current, '&modified')
    enew
    silent! execute 'bdelete '.l:current
  endif
endfunction

" Simple zoom toggle
function! s:custom_zoom()
  if exists('t:custom_zoomed')
    unlet t:custom_zoomed
    wincmd =
  else
    let t:custom_zoomed = { 'nr': bufnr('%') }
    vertical resize
    resize
    normal! ze
  endif
endfunction

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
" Text Manipulation Mappings
call TextManipulationMappings()
" Settings Toggle Mappings
call SettingsToggleMappings()
" Misc Mappings
" call JavaMappings()
call GitMappings()
