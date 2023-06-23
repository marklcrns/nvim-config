" ==================== General Settings ==================== "

" General {{{
set mouse=nv                 " Only allow mouse in normal and visual mode
set report=0                 " Don't report on line changes
set errorbells               " Trigger bell on error
set visualbell               " Use visual bell instead of beeping
set hidden                   " hide buffers when abandoned instead of unload
set fileformats=unix,dos,mac " Use Unix as the standard file type
set magic                    " For regular expressions turn magic on
set path+=**                 " Directories to search when using gf and friends
set isfname-==               " Remove =, detects filename in var=/foo/bar
set virtualedit=block        " Position cursor anywhere in visual block
set synmaxcol=2500           " Don't syntax highlight long lines
set formatoptions+=1         " Don't break lines after a one-letter word
set formatoptions+=q         " Allow formatting of comments with "gq"
set formatoptions+=t         " Auto-wrap text using textwidth
set formatoptions+=n         " Numbered list
set formatoptions-=o         " Disable comment-continuation (normal 'o'/'O')
set spelllang=en,cjk         " Set spell language and exclude 'cjk' or east asian charactes
set spellsuggest=best,9      " Only show 9 best spell suggest with z=
if has('patch-7.3.541')
  set formatoptions+=j       " Remove comment leader when joining lines
endif

if has('vim_starting')
  set encoding=utf-8
  scriptencoding utf-8
endif

" What to save for views and sessions:
set viewoptions=folds,cursor,curdir,slash,unix
set sessionoptions=curdir,help,tabpages,winsize

if has('mac')
  let g:clipboard = {
        \   'name': 'macOS-clipboard',
        \   'copy': {
        \      '+': 'pbcopy',
        \      '*': 'pbcopy',
        \    },
        \   'paste': {
        \      '+': 'pbpaste',
        \      '*': 'pbpaste',
        \   },
        \   'cache_enabled': 0,
        \ }
endif

if has('clipboard')
  set clipboard& clipboard+=unnamedplus
endif

" Wildmenu {{{
" --------
if has('wildmenu')
  set wildcharm=<Tab>         " Use <Tab> to cycle through wildmenu
  if ! has('nvim')
    set nowildmenu
    set wildmode=list:longest,full
  endif
  set wildignorecase
  set wildignore+=.git,.hg,.svn,.stversions,*.pyc,*.spl,*.o,*.out,*~,%*
  set wildignore+=*.jpg,*.jpeg,*.png,*.gif,*.zip,**/tmp/**,*.DS_Store
  set wildignore+=**/node_modules/**,**/bower_modules/**,*/.sass-cache/*
  set wildignore+=__pycache__,*.egg-info,.pytest_cache,.mypy_cache/**
endif

" Vim Directories {{{
" ---------------
set nobackup
set nowritebackup
set undofile noswapfile
set directory=$DATA_PATH/swap/,$DATA_PATH,~/tmp,/var/tmp,/tmp
set undodir=$DATA_PATH/undo/,$DATA_PATH,~/tmp,/var/tmp,/tmp
set backupdir=$DATA_PATH/backup/,$DATA_PATH,~/tmp,/var/tmp,/tmp
set viewdir=$DATA_PATH/view/
" Use the coc-spell-checker to do this
set spellfile=$VIM_PATH/spell/en.utf-8.add

" History saving
set history=2000

if has('nvim') && ! has('win32') && ! has('win64')
  set shada=!,'300,<50,@100,s10,h
else
  set viminfo='300,<10,@50,h,n$DATA_PATH/viminfo
endif

augroup user_persistent_undo
  autocmd!
  au BufWritePre /tmp/*          setlocal noundofile
  au BufWritePre COMMIT_EDITMSG  setlocal noundofile
  au BufWritePre MERGE_MSG       setlocal noundofile
  au BufWritePre *.tmp           setlocal noundofile
  au BufWritePre *.bak           setlocal noundofile
augroup END

" If sudo, disable vim swap/backup/undo/shada/viminfo writing
if $SUDO_USER !=# '' && $USER !=# $SUDO_USER
      \ && $HOME !=# expand('~'.$USER)
      \ && $HOME ==# expand('~'.$SUDO_USER)

  set noswapfile
  set nobackup
  set noundofile
  if has('nvim')
    set shada="NONE"
  else
    set viminfo="NONE"
  endif
endif

" Secure sensitive information, disable backup files in temp directories
if exists('&backupskip')
  set backupskip+=/tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*
  set backupskip+=.vault.vim
endif

" Disable swap/undo/viminfo/shada files in temp directories or shm
augroup user_secure
  autocmd!
  silent! autocmd BufNewFile,BufReadPre
        \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
        \ setlocal noswapfile noundofile nobackup nowritebackup viminfo= shada=
augroup END

" }}}

" Tabs and Indents {{{
" ----------------
set textwidth=80    " Text width maximum chars before wrapping
set expandtab       " expand tabs to spaces
set tabstop=2       " The number of spaces a tab is
set shiftwidth=2    " Number of spaces to use in auto(indent)
set softtabstop=-1  " Automatically keeps in sync with shiftwidth
set smarttab        " Tab insert blanks according to 'shiftwidth'
set autoindent      " Use same indenting on new lines
set smartindent     " Smart autoindenting on new lines
set shiftround      " Round indent to multiple of 'shiftwidth'

if exists('&breakindent')
  set breakindentopt=shift:2,min:20
endif

" }}}

" Timing {{{
" ------
set timeout ttimeout
set timeoutlen=300   " Time out on mappings
set ttimeoutlen=10   " Time out on key codes
set updatetime=100   " Idle time to write swap and trigger CursorHold
set redrawtime=1500  " Time in milliseconds for stopping display redraw

" }}}

" Searching {{{
" ---------
set ignorecase    " Search ignoring case
set smartcase     " Keep case when searching with *
set infercase     " Adjust case in insert completion mode
set incsearch     " Incremental search
set wrapscan      " Searches wrap around the end of the file
set hlsearch      " Highlight search results

set complete=.,w,b,k  " C-n completion: Scan buffers, windows and dictionary

" Slows down substitution greatly
" if exists('+inccommand')
"   set inccommand=split
" endif

if executable('rg')
  set grepformat=%f:%l:%m
  let &grepprg = 'rg --vimgrep' . (&smartcase ? ' --smart-case' : '')
elseif executable('ag')
  set grepformat=%f:%l:%m
  let &grepprg = 'ag --vimgrep' . (&smartcase ? ' --smart-case' : '')
endif

" }}}

" Behavior {{{
" --------
set autoread                    " Auto readfile
set nowrap                      " No wrap by default
set linebreak                   " Break long lines at 'breakat'
set breakat=\ \ ;:,!?           " Long lines break chars
set nostartofline               " Cursor in same column for few commands
set whichwrap+=h,l,<,>,[,],~    " Move to following line on certain keys
set splitbelow splitright       " Splits open bottom right
set switchbuf=useopen           " Jump to the first open window
set backspace=indent,eol,start  " Intuitive backspacing in insert mode
set diffopt=filler,iwhite       " Diff mode: show fillers, ignore whitespace
set completeopt=menu,menuone    " Always show menu, even for one item
set completeopt+=noinsert

if exists('+completepopup')
  set completeopt+=popup
  set completepopup=height:4,width:60,highlight:InfoPopup
endif

if has('nvim-0.5')
  set jumpoptions=stack         " Use the new Neovim :h jumplist-stack
  set switchbuf+=uselast        " Jump to the last window
endif

if has('patch-8.1.0360') || has('nvim-0.4')
  set diffopt+=internal,algorithm:patience
  " set diffopt=indent-heuristic,algorithm:patience
endif
" }}}

" Editor UI {{{
set number              " Show number
set relativenumber      " Show relative number
set noshowmode          " Don't show mode on bottom
set noruler             " Disable default status ruler
set shortmess=aoOTI     " Shorten messages and don't show intro
set scrolloff=2         " Keep at least 2 lines above/below
set sidescrolloff=5     " Keep at least 5 lines left/right
set fillchars+=eob:\ ,fold:\ ,foldopen:,foldsep:\ ,foldclose:
set fillchars+=vert:\│  " add a bar for vertical splits
set fillchars+=diff:╱   " Diagonal lines in place of deleted lines in diff-mode
set list
let &showbreak='↳  '
" set listchars=tab:\│\ ,extends:⟫,precedes:⟪,nbsp:␣,trail:·
set listchars=tab:»·,extends:⟫,precedes:⟪,nbsp:␣,trail:·
set listchars+=eol:↴
" set listchars+=space:⋅
set title
" Title length.
set titlelen=95
" Title string.
let &g:titlestring="
      \ %{expand('%:p:~:.')}%(%m%r%w%)
      \ %<\[%{fnamemodify(getcwd(), ':~')}\] - Neovim"

set showmatch           " Jump to matching bracket
set matchpairs+=<:>     " Add HTML brackets to pair matching
set matchtime=1         " Tenths of a second to show the matching paren

" set winwidth=30         " Minimum width for active window
" set winminwidth=10      " Minimum width for inactive windows
" set winheight=4         " Minimum height for active window
" set winminheight=1      " Minimum height for inactive window
set showtabline=2       " Always show the tabs line
set pumheight=15        " Pop-up menu's line height
set helpheight=12       " Minimum help window height
set previewheight=12    " Completion preview height

set showcmd             " Show command in status line
set cmdheight=2         " Height of the command line
set cmdwinheight=5      " Command-line lines
set noequalalways       " Don't resize windows on split or close
set laststatus=2        " Always show a status line
set colorcolumn=+0      " Column highlight at textwidth's max character-limit
set display=lastline
set cursorline
set signcolumn=auto:2

if has('folding') && has('vim_starting')
  set foldenable
  set foldmethod=syntax
  set foldlevelstart=99
endif

if has('conceal') && v:version >= 703
  " For snippet_complete marker
  set conceallevel=2
  " set concealcursor=niv
endif

if exists('+previewpopup')
  set previewpopup=height:10,width:60
endif

" Pseudo-transparency for completion menu and floating windows
if has('termguicolors') && &termguicolors
  if exists('&pumblend')
    set pumblend=10
  endif
  if exists('&winblend')
    set winblend=10
  endif
endif

if exists('g:neovide') || exists('g:Gui') || exists('g:GuiLoaded') || has("gui_running") || has('gui')
  function! AdjustFontSize(amount)
    let g:guifontsize = g:guifontsize+a:amount
    exec "set guifont=" . g:guifont . ":h" . g:guifontsize
  endfunction

  noremap <silent> <C-ScrollWheelUp> :call AdjustFontSize(1)<CR>
  noremap <silent> <C-ScrollWheelDown> :call AdjustFontSize(-1)<CR>
  inoremap <silent> <C-ScrollWheelUp> <Esc>:call AdjustFontSize(1)<CR>a
  inoremap <silent> <C-ScrollWheelDown> <Esc>:call AdjustFontSize(-1)<CR>a

  exec "set guifont=" . g:guifont . ":h" . g:guifontsize
endif

" [SOLVED] WSL2 system clipboard not working.
" https://github.com/Kethku/neovide/issues/544#issuecomment-820519937
" Note: make sure win32yank.exe is sourced in $PATH before other system
" clipboard utility, such as xclip, for it to work. /usr/local/bin works.
if exists('g:neovide')
  let g:neovide_cursor_vfx_mode = "ripple"
  let g:neovide_scroll_animation_length = 0.25
  let g:neovide_hide_mouse_when_typing = v:true
  let g:neovide_cursor_trail_size = 0.8
  let g:neovide_refresh_rate = 60
  let g:neovide_no_idle = v:true
  let g:neovide_transparency = 0.9

  " let g:neovide_scale_factor=1.0
  function! ChangeScaleFactor(delta)
    let g:neovide_scale_factor = g:neovide_scale_factor * a:delta
  endfunction
  nnoremap <expr><C-=> ChangeScaleFactor(1.05)
  nnoremap <expr><C--> ChangeScaleFactor(1/1.05)

  " Allow copy paste in neovide
  let g:neovide_input_use_logo = 1
  map <C-S-v> "+p<CR>
  map! <C-S-v> <C-R>+
  tmap <C-S-v> <C-R>+
  vmap <C-S-c> "+y<CR>
endif
" }}}
