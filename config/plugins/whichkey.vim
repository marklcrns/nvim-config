let g:which_key_timeout = 200
let g:which_key_exit = ["\<C-[>", "\<C-c>", "\<C-g>"]
let g:which_key_sep = '»'

let g:which_key_display_names = {
      \       ' ': '␣',
      \   '<TAB>': '⇆',
      \ '<S-TAB>': 'S⇆',
      \    '<CR>': '↵',
      \ }

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
          \ 'a' : 'Jump to window with the disassembly',
          \ 'b' : 'Add line breapoint under current line',
          \ 'B' : 'Delete line breakpoint under current line',
          \ 'd' : 'Termdebug <exec>',
          \ 'e' : 'Evaluate variable undercursor or VISUAL',
          \ 'g' : 'Jump to gdb window',
          \ 'f' : 'Jump to window with the source code',
          \ 'h' : 'Continue until next breakpoint',
          \ 'j' : 'Step over (next)',
          \ 'k' : 'Step out (finish)',
          \ 'l' : 'Step into (step)',
          \ 'p' : 'Jump to window with running program',
          \ 'r' : 'Run program (accepts program cmdline arguments)',
          \ 'x' : 'Stop (interrupt) execution',
          \ 'A' : 'Set arguments for the next Run',
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
          \ 'S' : 'Save all buffers',
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
                \ 'd' : 'Diff unsaved changes',
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
    \ 'q' : 'Adaptive buffer quit',
    \ 'Q' : 'Quit vim',
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
            \ 'r' : 'Search and replace',
            \ 'R' : 'Search and replace current line',
            \ 'w' : 'Wrap paragraph to textwidth',
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
    \ 't' : {
          \ 'name' : '+tab-operate',
             \ 'n' : 'New tab',
             \ 'e' : 'Tab edit ',
             \ 'm' : 'Move tab',
             \ 'q' : 'Close current tab',
          \ },
    \ 'z' : 'Toggle fold at current line',
    \ 'Z' : 'Focus the current fold by closing all others',
    \ }

let g:which_key_localmap = {
      \ 'name' : '+local-leader-key'  ,
      \ 'o' : {
            \ 'name' : '+open',
                \ 'l' : 'Toggle locationlist',
                \ 'q' : 'Toggle quickfix',
            \ },
      \ 'q'    : 'Toggle quickfix',
      \ 'r'    : 'Quick run',
      \ 's' : {
            \ 'name' : '+ui-toggles',
               \ 'b' : 'Toggle dark/light background',
               \ 'e' : 'Conceal toggle',
               \ 'g' : 'Gutter toggle',
               \ 's' : 'Spell checker toggle',
               \ 't' : 'Tab char toggle',
               \ 'r' : 'Auto split resize toggle',
               \ 'v' : 'Virtualedit mode toggle',
               \ 'w' : 'Text wrap view toggle',
               \ 'W' : 'Text wrapping toggle',
               \ 'l' : {
                     \ 'name' : '+cursor',
                     \ 'c' : 'Cursorcolumn toggle',
                     \ 'l' : 'Cursorline toggle',
                     \ 'x' : 'Crosshair toggle',
                     \ },
            \ },
      \ }

let g:which_key_lsbgmap = {
      \ 'name' : '+left-square-brackets',
         \ '[' : 'Prev function beginning',
         \ ']' : 'Prev function end',
         \ '=' : 'Marker any prev',
         \ '-' : 'Marker same prev',
         \ "'" : 'Marker unique prev',
         \ '"' : 'Comment prev',
         \ 'b' : 'Buffer prev',
         \ 'B' : 'Buffer first',
         \ 'c' : 'Diff jump prev',
         \ 'd' : 'Coc diagnostic prev',
         \ 'g' : 'Git prev chunk',
         \ 'l' : 'Locationlist prev',
         \ 'L' : 'Locationlist first',
         \ 't' : 'Tab prev',
         \ 'T' : 'Tab first',
         \ 'q' : 'Quickfix prev',
         \ 'Q' : 'Quickfix first',
      \ }

let g:which_key_rsbgmap = {
      \ 'name' : '+right-square-brackets',
         \ ']' : 'Next function beginning',
         \ '[' : 'Next function end',
         \ '=' : 'Marker any next',
         \ '-' : 'Marker same next',
         \ "'" : 'Marker unique next',
         \ '"' : 'Comment next',
         \ 'b' : 'Buffer next',
         \ 'B' : 'Buffer last',
         \ 'c' : 'Diff jump next',
         \ 'd' : 'Coc diagnostic next',
         \ 'g' : 'Git next chunk',
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
      \ }

let g:which_key_smap = {
      \ 'name' : '+s-key',
      \ }

let g:which_key_map['g'] = { 'name': '+git' }
let g:which_key_map['g']['D'] = ['GitOpenDirty', 'Open all dirty in splits']

call which_key#register('<Space>', 'g:which_key_map')
call which_key#register(';', 'g:which_key_localmap')
call which_key#register(']', 'g:which_key_rsbgmap')
call which_key#register('[', 'g:which_key_lsbgmap')
call which_key#register('d', 'g:which_key_dmap')
call which_key#register('s', 'g:which_key_smap')
call which_key#register('g', 'g:which_key_gmap')

let s:leader_key=substitute(get(g:,"mapleader","\\"), ' ', '<Space>', '')
let s:localleader_key= get(g:,'maplocalleader',';')
execute 'nnoremap <silent> <Leader> :<c-u>WhichKey "'.s:leader_key.'"<CR>'
execute 'vnoremap <silent> <Leader> :<c-u>WhichKeyVisual "'.s:leader_key.'"<CR>'
execute 'nnoremap <silent> <LocalLeader> :<c-u>WhichKey "' .s:localleader_key.'"<CR>'
execute 'vnoremap <silent> <LocalLeader> :<c-u>WhichKeyVisual "'.s:localleader_key.'"<CR>'
execute 'nnoremap <silent> [ :<c-u>WhichKey "["<CR>'
execute 'nnoremap <silent> ] :<c-u>WhichKey "]"<CR>'

augroup user_events
  autocmd! FileType which_key
  autocmd  FileType which_key set laststatus=0 noshowmode noruler
    \| autocmd BufLeave <buffer> set laststatus=2 showmode ruler
augroup END

