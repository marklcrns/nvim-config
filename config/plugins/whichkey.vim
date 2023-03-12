let g:which_key_timeout = 200
let g:which_key_exit = ["\<C-[>", "\<C-c>", "\<C-g>", "\<Esc>"]
let g:which_key_sep = '»'

let g:which_key_display_names = {
      \       ' ': '␣',
      \   '<TAB>': '⇆',
      \ '<S-TAB>': 'S⇆',
      \    '<CR>': '↵',
      \ }

    """" Termdebug
          " \ 'a' : 'Jump to window with the disassembly',
          " \ 'b' : 'Add line breapoint under current line',
          " \ 'B' : 'Delete line breakpoint under current line',
          " \ 'd' : 'Termdebug <exec>',
          " \ 'e' : 'Evaluate variable undercursor or VISUAL',
          " \ 'g' : 'Jump to gdb window',
          " \ 'f' : 'Jump to window with the source code',
          " \ 'h' : 'Continue until next breakpoint',
          " \ 'j' : 'Step over (next)',
          " \ 'k' : 'Step out (finish)',
          " \ 'l' : 'Step into (step)',
          " \ 'p' : 'Jump to window with running program',
          " \ 'r' : 'Run program (accepts program cmdline arguments)',
          " \ 'x' : 'Stop (interrupt) execution',
          " \ 'A' : 'Set arguments for the next Run',

let g:which_key_map = {
    \ 'name' : '+leader-key',
    \ ';' : {
          \ 'name' : '+single-purpose',
          \ 'm' : 'Open clipboard register relative path as markdown',
          \ },
    \ '1' : 'Go to first tab',
    \ '5' : 'Go to previous tab',
    \ '9' : 'Go to last tab',
    \ 'b' : {
          \ 'name' : '+buffer-operate',
          \ 'a' : {
                \ 'name' : '+all',
                \ 'h' : 'Open all buffers in horizontal split',
                \ 'v' : 'Open all buffers in vertical split',
                \ },
          \ },
    \ 'd' : {
          \ 'name' : '+debug',
          \ },
    \ 'e' : {
          \ 'name' : '+file-explore',
          \ 'w' : 'Edit file from current directory',
          \ 'g' : 'Edit file in split from current directory',
          \ 'v' : 'Edit file in vertical split from current directory',
          \ 't' : 'Edit file in new tab from current directory',
          \ },
    \ 'f' : {
          \ 'name' : '+file-manager',
          \ 'a' : 'Save all buffers',
          \ 'D' : 'Delete current file',
          \ 'g' : 'Vimgrep (project-wide) and load into quickfix',
          \ 'q' : 'Save and quit',
          \ 'Q' : 'Save all and quit',
          \ 'r' : {
                \ 'name' : '+change-directory',
                \ 'r' : 'Change working directory to root',
                \ 'd' : 'Change working directory to current file',
                \ 'l' : 'Change working directory to current file (window only)',
                \ },
          \ 's' : 'Save buffer',
          \ 'w' : 'Wipe buffer',
          \ 'y' : {
                \ 'name' : '+yank-path',
                  \ 'e' : 'Yank absolute file path without extension',
                  \ 'E' : 'Yank relative file path without extension',
                  \ 'p' : 'Yank absolute file path',
                  \ 'P' : 'Yank relative file path',
                  \ 'f' : 'Yank file name without extension',
                  \ 'F' : 'Yank file name',
                  \ 'd' : 'Yank absolute directory path',
                  \ 'D' : 'Yank relative directory path',
                  \ 'o' : 'Open/Create file from yanked path',
                  \ 'x' : 'Yank file extension only',
                \ },
          \ },
    \ 'G' : 'Grep operator',
    \ 'i' : {
          \ 'name' : '+interface',
          \ 'd' : {
                \ 'name' : '+diff',
                \ 'o' : 'Diff unsaved changes',
                \ 'h' : 'Horizontal file diff split from current directory',
                \ 'H' : 'Horizontal file diff split from $HOME',
                \ 'v' : 'Vertical file diff split from current directory',
                \ 'V' : 'Vertical file diff split from $HOME',
                \ },
          \ },
    \ 'J' : 'Move line down',
    \ 'K' : 'Move line up',
    \ 'l' : {
          \ 'name' : '+languages',
          \ 'j' : {
                \ 'name' : '+java',
                \ 'c' : 'Javac compile',
                \ 'C' : 'Javac compile all from directory',
                \ 'j' : 'Save compile and run in next tmux pane',
                \ 'r' : 'Save compile and run Java in vim terminal',
                \ },
          \ 'g' : {
                \ 'name' : '+grammar',
                \ },
          \ 'm' : {
                \ 'name' : '+markdown',
                \ },
          \ 't' : {
                \ 'name' : '+tools',
                \ },
          \ },
    \ 'o' : {
          \ 'name' : '+open',
             \ 'f' : 'Open file in firefox browser',
             \ 'g' : 'Open file in google chrome browser',
             \ 'o' : 'Open file with xdg',
          \ },
    \ 'p' : {
          \ 'name' : '+vim-manager',
             \ 's' : 'Source VIMRC',
          \ },
    \ 'r' : {
          \ 'name' : '+text-manipulate',
             \ ' ' : 'Remove whitespaces',
             \ 'c' : 'Lowercase entire file (or selected lines)',
             \ 'C' : 'Capitalize entire file (or selected lines)',
             \ 'e' : {
                   \ 'name' : '+register',
                     \ 'g' : 'display-register(+abjk)',
                     \ 'j' : 'Cycle forward (copy selected if visual)',
                     \ 'J' : 'Paste cycle forward',
                     \ 'k' : 'Cycle backward (copy selected if visual)',
                     \ 'K' : 'Paste cycle backward',
                   \ },
            \ 'F' : 'Search and replace confirmation last selected',
            \ 'i' : 'Fix indentation',
            \ 'l' : 'Enumerate selected lines (visual)',
            \ 'L' : 'Enumerate entire file',
            \ 'n' : 'Search forward and replace',
            \ 'N' : 'Search backward and replace',
            \ 'p' : 'Duplicate paragraph',
            \ 'P' : 'Smart paste',
            \ 'r' : 'Search and replace',
            \ 'R' : 'Search and replace current line',
            \ 'y' : {
                  \ 'name' : '+yank-text',
                  \ 'a' : 'Yank all file content',
                  \ 'p' : 'Replace all with yanked texts',
                  \ },
          \ },
    \ 's' : {
          \ 'name' : '+sessions',
          \ 'd' : 'Detach session',
          \ 'D' : 'Delete session {name}',
          \ 'l' : 'Load session {name}',
          \ 'L' : 'List sessions',
          \ 's' : 'Save session {name}',
          \ 'q' : 'Close session',
          \ },
    \ 'q' : 'Quit without saving',
    \ 'Q' : 'Quit vim without saving',
    \ 't' : {
          \ 'name' : '+tab-operate',
             \ 'n' : 'New tab',
             \ 'e' : 'Tab edit ',
             \ 'm' : 'Move tab',
             \ 'q' : 'Close current tab',
          \ },
    \ 'w' : {
          \ 'name' : '+window-operate',
             \ 'c' : 'Close current window',
             \ 'v' : 'Open vertical split',
             \ 'V' : 'Open vertical split (stay in current)',
             \ 'g' : 'Open horizontal split',
             \ 'G' : 'Open horizontal split (stay in current)',
          \ },
    \ 'z' : 'Toggle fold at current line',
    \ 'Z' : 'Focus the current fold by closing all others',
    \ }

let g:which_key_localmap = {
      \ 'name' : '+local-leader-key'  ,
      \ 'o' : {
            \ 'name' : '+open',
                \ 'l' : {
                  \ 'name' : '+locationlist'  ,
                  \ 'l' : 'Toggle locationlist',
                  \ },
                \ 'q' : {
                  \ 'name' : '+quickfix'  ,
                  \ 'q' : 'Toggle quickfix',
                  \ },
            \ },
      \ 'r'    : 'Quick run',
      \ 's' : {
            \ 'name' : '+settings-toggles',
               \ 'b' : 'dark/light background',
               \ 'e' : 'Conceal toggle',
               \ 'f' : 'Format on save toggle',
               \ 'F' : 'Foldcolumn toggle',
               \ 'g' : 'Gutter toggle',
               \ 's' : 'Spell checker toggle',
               \ 't' : 'Tab char toggle',
               \ 'r' : 'Auto split resize toggle',
               \ 'v' : 'Virtualedit mode toggle',
               \ 'w' : 'Text wrap view toggle',
               \ 'W' : 'Text wrapping toggle',
               \ 'c' : {
                     \ 'name' : '+cursor',
                     \ 'c' : 'Cursorcolumn toggle',
                     \ 'l' : 'Cursorline toggle',
                     \ 'x' : 'Crosshair toggle',
                     \ },
            \ },
      \ }

let g:which_key_lsbmap = {
      \ 'name' : '+left-square-brackets',
         \ '`' : 'Jump to prev mark',
         \ "'" : 'Jump to start of prev line with mark',
         \ '-' : 'Jump to start of prev line with marker of same type',
         \ '=' : 'Jump to start of prev line with marker of any type',
         \ 'b' : 'Buffer prev',
         \ 'B' : 'Buffer first',
         \ 'c' : 'Diff jump prev',
         \ 'l' : 'Locationlist prev',
         \ 'L' : 'Locationlist first',
         \ 't' : 'Tab prev',
         \ 'T' : 'Tab first',
         \ 'q' : 'Quickfix prev',
         \ 'Q' : 'Quickfix first',
      \ }

let g:which_key_rsbmap = {
      \ 'name' : '+right-square-brackets',
         \ '`' : 'Jump to next mark',
         \ "'" : 'Jump to start of prev line with mark',
         \ '-' : 'Jump to start of next line with marker of same type',
         \ '=' : 'Jump to start of next line with marker of any type',
         \ 'b' : 'Buffer next',
         \ 'B' : 'Buffer last',
         \ 'c' : 'Diff jump next',
         \ 'l' : 'Locationlist next',
         \ 'L' : 'Locationlist last',
         \ 't' : 'Tab next',
         \ 'T' : 'Tab last',
         \ 'q' : 'Quickfix next',
         \ 'Q' : 'Quickfix last',
      \ }

let g:which_key_dmap = {
      \ 'name' : '+d-key',
      \ }

let g:which_key_gmap = {
      \ 'name' : '+g-key',
      \ 'p' : 'Select last pasted',
      \ 'K' : 'Show Dev help under cursor',
      \ 'o' : 'Go to file in vertical split',
      \ }

let g:which_key_smap = {
      \ 'name' : '+s-key',
      \ }

let g:which_key_map['c'] = { 'name': '+code' }
let g:which_key_map['g'] = { 'name': '+git' }
let g:which_key_map['g']['D'] = ['GitOpenDirty', 'Open all dirty in splits']
let g:which_key_localmap['r'] = { 'name': '+code-runner' }

let s:leader_key=substitute(get(g:,'mapleader','\'), ' ', '<Space>', '')
let s:localleader_key= get(g:,'maplocalleader','\')
execute "nnoremap <silent> <Leader>       :<c-u>WhichKey '" . s:leader_key . "'<CR>"
execute "vnoremap <silent> <Leader>       :<c-u>WhichKeyVisual '" . s:leader_key . "'<CR>"
execute "nnoremap <silent> <LocalLeader>  :<c-u>WhichKey '" . s:localleader_key . "'<CR>"
execute "vnoremap <silent> <LocalLeader>  :<c-u>WhichKeyVisual '" . s:localleader_key . "'<CR>"

call which_key#register(s:leader_key, 'g:which_key_map')
call which_key#register(s:localleader_key, 'g:which_key_localmap')
call which_key#register(']', 'g:which_key_rsbmap', 'n')
call which_key#register('[', 'g:which_key_lsbmap', 'n')
call which_key#register('d', 'g:which_key_dmap', 'n')
call which_key#register('s', 'g:which_key_smap', 'n')
call which_key#register('g', 'g:which_key_gmap', 'n')

augroup user_events
  autocmd! FileType which_key
  autocmd  FileType which_key set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

