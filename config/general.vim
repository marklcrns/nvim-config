" ==================== General Settings ==================== "

" DISPLAY SETTINGS -------------------- {{{
" Enable true color
if has('termguicolors')
  set termguicolors
endif
" Gutter settings
set number
set relativenumber
set scrolloff=3 " Keeps some screen visible while scrolling
set cmdheight=2 " Height of the command line
" }}} DISPLAY SETTINGS

" UI SETTINGS -------------------- {{{
set lazyredraw          " improve scrolling performance when navigating through large results
" Encoding
if has('vim_starting')
  set encoding=UTF-8
  scriptencoding UTF-8
endif
" Folds
if has('folding')
  set foldenable
  set foldmethod=syntax
  set foldlevelstart=99
endif
" Status and tab line
set laststatus=2
set showtabline=2
set statusline=-       " hide file name in statusline
set fillchars+=vert:\│ " add a bar for vertical splits
set hidden             " Hide buffers instead of killing when abandoned
" set textwidth=80       " Text width maximum chars before wrapping text on insert
set expandtab          " Don't expand tabs to spaces.
set tabstop=2          " The number of spaces a tab is
set softtabstop=2      " While performing editing operations
set shiftwidth=2       " Number of spaces to use in auto(indent)
set smarttab           " Tab insert blanks according to 'shiftwidth'
set autoindent         " Use same indenting on new lines
set smartindent        " Smart autoindenting on new lines
set shiftround         " Round indent to multiple of 'shiftwidth'
set signcolumn=auto:3
set colorcolumn=80
set sidescroll=5       " shows number of chars instantly when scrolling horizontally
set nowrap             " Disables text wrap
set breakindent        " Enable wrap indentation
" indent by an additional 2 characters on wrapped lines,
" when line >= 40 characters, put 'showbreak' at start of line
set breakindentopt=shift:4,min:40,sbr
let &showbreak='>>> '       " append '>>> ' to indent wrapped lines
set cursorline         " Highlights entire line of current cursor position"
" set cursorcolumn       " Highlights column of current cursor position
" Live interactive search and replace
set inccommand=split   " Options: split or nosplit
" }}} UI SETTINGS

" FILE MANAGEMENT SETTINGS -------------------- {{{
set autoread
set autowrite
set confirm
set splitright
set splitbelow
set browsedir=buffer
set undofile noswapfile nobackup
set directory=$DATA_PATH/swap//,$DATA_PATH,~/tmp,/var/tmp,/tmp
set undodir=$DATA_PATH/undo//,$DATA_PATH,~/tmp,/var/tmp,/tmp
set backupdir=$DATA_PATH/backup/,$DATA_PATH,~/tmp,/var/tmp,/tmp
set viewdir=$DATA_PATH/view/
set spellfile=$VIM_PATH/spell/en.utf-8.add
" History saving
set history=1000
if has('nvim')
  set shada='1000,<50,@100,s10,h
else
  set viminfo='1000,<10,@50,h,n$DATA_PATH/viminfo
endif
" If sudo, disable vim swap/backup/undo/shada/viminfo writing
if $SUDO_USER !=# '' && $USER !=# $SUDO_USER
      \ && $HOME !=# expand('~'.$USER)
      \ && $HOME ==# expand('~'.$SUDO_USER)
  set noswapfile
  set nobackup
  set nowritebackup
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
" }}} FILE MANAGEMENT SETTINGS

" MISC SETTINGS -------------------- {{{
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
" Set clipboard register
if has('clipboard')
  set clipboard& clipboard+=unnamedplus
endif
set history=5000
set timeout ttimeout
set timeoutlen=500 " Time out on mappings
set updatetime=400 " Idle time to write swap and trigger CursorHold
set ttimeoutlen=10 " Time out on key codes
set mouse=a        " Enable mouse support
set magic          " Enable regex in search without backslashes. Same as '\v'
" Nvim specific settings
if !has('nvim')
  set ttymouse=sgr
  set cryptmethod=blowfish2
  set ttyfast
endif
" }}} MISC SETTINGS

" COMPLETION AND SYNTAX SETTINGS -------------------- {{{
if has('conceal')
  set conceallevel=2
  " set concealcursor=niv
endif
set shortmess=aFc
set completefunc=emoji#complete
set completeopt=menuone,preview
set completeopt+=noselect,noinsert
set list
set listchars=tab:»·,nbsp:+,trail:·,extends:→,precedes:←
set backspace=2
set backspace=indent,eol,start
set regexpengine=1
set ignorecase      " Search ignoring case
set smartcase       " Keep case when searching with *
set infercase       " Adjust case in insert completion mode
set incsearch       " Incremental search
set hlsearch        " Highlight search results
set wrapscan        " Incremental search stops wrapping around at the end of the file
set showmatch       " Jump to matching bracket
set matchpairs+=<:> " Add HTML brackets to pair matching
set matchtime=1     " Tenths of a second to show the matching paren
set cpoptions-=m    " showmatch will wait 0.5s or until a char is typed
set grepprg=rg\ --vimgrep\ $*
set wildignore+=*.so,*~,*/.git/*,*/.svn/*,*/.DS_Store,*/tmp/*
" }}} COMPLETION AND SYNTAX SETTINGS


" ==================== Autocommands ==================== "

augroup MyAutoCmds
  autocmd!
  " Disable swap/undo/viminfo/shada files in temp directories or shm
  silent! autocmd BufNewFile,BufReadPre
        \ /tmp/*,$TMPDIR/*,$TMP/*,$TEMP/*,*/shm/*,/private/var/*,.vault.vim
        \ setlocal noswapfile noundofile nobackup nowritebackup viminfo= shada=
  " Auto-resize splits when Vim gets resized.
  autocmd VimResized * wincmd =
  " autoread file to check and update new changes in current buffer
  autocmd FocusGained,BufEnter * :checktime
  " Triger `autoread` when files changes on disk
  " https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
  " https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
  autocmd FocusGained,BufEnter,CursorHold,CursorHoldI *
        \ if mode() !~ '\v(c|r.?|!|t)' && getcmdwintype() == '' | checktime | endif
  " Notification after file change
  " https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
  autocmd FileChangedShellPost *
        \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
  " Disables automatic commenting on newline:
  autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o
  " " Always choose read-only when SwapExists
  " autocmd SwapExists * let v:swapchoice = "o"
augroup END

augroup CursorUI
  autocmd!
  " disable cursorline on InsertEnter
  autocmd InsertEnter * set nocursorline
  " reenable cursorline on InsertLeave when activated
  autocmd InsertLeave *
        \ if g:activate_cursorline == 1
        \ | set cursorline
        \ | endif
augroup END

" Automatically create non existing directory in buffer's path when saved
" Ref: https://stackoverflow.com/a/4294176/11850077
function s:MkNonExDir(file, buf)
  if empty(getbufvar(a:buf, '&buftype')) && a:file!~#'\v^\w+\:\/'
    let dir=fnamemodify(a:file, ':h')
    if !isdirectory(dir)
      call mkdir(dir, 'p')
    endif
  endif
endfunction

augroup AutoMkNonExDir
  autocmd!
  autocmd BufWritePre * :call s:MkNonExDir(expand('<afile>'), +expand('<abuf>'))
augroup END

augroup JavaEditorConfig
  autocmd!
  autocmd Filetype java set tabstop=4 softtabstop=4 shiftwidth=4
augroup END

