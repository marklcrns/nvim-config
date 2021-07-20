" Plugin key settings
let s:enable_whichkey = dein#is_sourced('vim-which-key')

if s:enable_whichkey
  " Extra mappings
  nnoremap <silent> ?s :<c-u>WhichKey 's'<CR>
  vnoremap <silent> ?s :<c-u>WhichKeyVisual 's'<CR>
  nnoremap <silent> ?d :<c-u>WhichKey 'd'<CR>
  vnoremap <silent> ?d :<c-u>WhichKeyVisual 'd'<CR>
  nnoremap <silent> ?g :<c-u>WhichKey 'g'<CR>
  vnoremap <silent> ?g :<c-u>WhichKeyVisual 'g'<CR>
endif

if dein#tap('dein.vim')
  nnoremap <silent> <Leader>pu  :call dein#update()<CR>
  nnoremap <silent> <Leader>pr  :call dein#recache_runtimepath()<CR>
  nnoremap <silent> <Leader>pl  :echo dein#get_log()<CR>
  nnoremap <silent> <Leader>pL  :echo dein#get_updates_log()<CR>
  nnoremap <silent> <Leader>pd  :call map(dein#check_clean(), "delete(v:val, \"rf\")")<CR>

  if s:enable_whichkey
    let g:which_key_map['p'] = {
          \ 'name' : '+plugin-manager',
          \ 'd' : 'Delete unused plugins',
          \ 'l' : 'Get log',
          \ 'L' : 'Get update log',
          \ 'r' : 'Recache runtimepath',
          \ 'u' : 'Update plugins',
          \ }
  endif

  if s:enable_whichkey
    let g:which_key_map['c'] = {
          \ 'name' : '+coc',
             \ 'a' : 'Code action text object',
             \ 'c' : 'Code action current word',
             \ 'C' : 'Open coc config',
             \ 'F' : 'Coc format',
             \ 'g' : {
                   \ 'name' : '+coc-git',
                   \ 'b' : 'Preview line in git browser',
                   \ 'B' : 'Copy line git url to clipboard',
                   \ 'c' : 'Coc show last commit of current line',
                   \ 'd' : 'Git diff cached',
                   \ 'f' : 'Toggle fold all except git chunks',
                   \ 'i' : 'Preview git chunk under cursor',
                   \ 's' : 'Coc list status changes',
                   \ 't' : 'Stage git chunk under cursor',
                   \ 'u' : 'Undo git chunk changes under cursor',
                  \ },
             \ 'j' : 'Coc list next',
             \ 'k' : 'Coc list prev',
             \ 'l' : {
                   \ 'name' : '+coc-list',
                     \ 'c' : 'Coc commands',
                     \ 'd' : 'Coc diagnostics',
                     \ 'e' : 'Coc extensions',
                     \ 'm' : 'Coc marketplace',
                     \ 'o' : 'File outline',
                     \ 'r' : 'Resume last coc list',
                     \ 's' : 'Search workspace symbols',
                     \ 'w' : 'Coc rgrep selected word or motion',
                     \ 'W' : 'Coc grep cursor word in buffer',
                     \ 'y' : 'Coc yank list',
                   \ },
            \ 'n' : 'Coc rename variable under cursor',
            \ 'r' : 'Coc refactor word under cursor',
            \ 's' : 'Coc search {prompt}',
            \ 'S' : 'Coc search word match {prompt}',
            \ 't' : {
                  \ 'name' : '+coc-toggles',
                  \ 'g' : 'Toggle coc git gutter',
                  \ 's' : 'Toggle coc spell checker',
                  \ },
            \ 'q' : 'Coc autofix current line',
            \ 'x' : 'Coc cursors operate',
          \ }
  endif
endif

if dein#tap('any-jump.vim')
  nnoremap <silent> <leader>ab :AnyJumpBack<CR>
  nnoremap <silent> <Leader>aj :AnyJump<CR>
  xnoremap <silent> <Leader>aj :AnyJumpVisual<CR>
  nnoremap <silent> <leader>al :AnyJumpLastResults<CR>

  if s:enable_whichkey
    let g:which_key_map['a'] = {
          \ 'name' : '+any-jump',
          \ 'b' : 'Open previously opened file',
          \ 'j' : 'Open jump to definition window',
          \ 'l' : 'Open last jump to definition result',
          \ }
  endif
endif

if dein#tap('coc.nvim')
  nnoremap <silent> <leader>cC :<C-u>CocConfig<Cr>
  " Using CocList
  " Show commands
  nnoremap <silent> <leader>clc  :<C-u>CocList commands<cr>
  " Show all diagnostics
  nnoremap <silent> <leader>cld  :<C-u>CocList diagnostics<cr>
  " Manage extensions
  nnoremap <silent> <leader>cle  :<C-u>CocList extensions<cr>
  " Marketplace list
  nnoremap <silent> <leader>clm  :<C-u>CocList marketplace<cr>
  " Find symbol of current document
  nnoremap <silent> <leader>clo  :<C-u>CocList outline<cr>
  " Resume latest coc list
  nnoremap <silent> <leader>clr  :<C-u>CocListResume<CR>
  " Search workspace symbols
  nnoremap <silent> <leader>cls  :<C-u>CocList -I symbols<cr>
  " Show yank list (coc-yank)
  nnoremap <silent> <leader>cly  :<C-u>CocList -A --normal yank<cr>

  " Rgrep selected or by motion
  nnoremap <leader>clw :<C-u>set operatorfunc=<SID>GrepFromSelected<CR>g@
  vnoremap <leader>clw :<C-u>call <SID>GrepFromSelected(visualmode())<CR>

  function! s:GrepFromSelected(type)
    let saved_unnamed_register = @@
    if a:type ==# 'v'
      normal! `<v`>y
    elseif a:type ==# 'char'
      normal! `[v`]y
    else
      return
    endif
    let word = substitute(@@, '\n$', '', 'g')
    let word = escape(word, '| ')
    let @@ = saved_unnamed_register
    execute 'CocList grep '.word
  endfunction

  " Grep in current buffer under cursor
  nnoremap <silent> <Leader>clW  :exe 'CocList -I --normal --input='.expand('<cword>').' words'<CR>

  " Do default action for next item.
  nnoremap <silent> <leader>cj  :<C-u>CocNext<CR>
  " Do default action for previous item.
  nnoremap <silent> <leader>ck  :<C-u>CocPrev<CR>
  " Use `[d` and `]d` for navigate diagnostics
  nmap <silent> [d <Plug>(coc-diagnostic-prev)
  nmap <silent> ]d <Plug>(coc-diagnostic-next)
  " Remap for rename current word
  nmap <leader>cn <Plug>(coc-rename)
  " Remap for format selected region
  vmap <leader>cF <Plug>(coc-format-selected)
  nmap <leader>cF <Plug>(coc-format-selected)
  " Applying codeAction to the selected region.
  xmap <silent><leader>ca <Plug>(coc-codeaction-selected)
  nmap <silent><leader>ca <Plug>(coc-codeaction-selected)
  " xmap <leader>a  <Plug>(coc-codeaction-selected)
  " nmap <leader>a  <Plug>(coc-codeaction-selected)
  " Remap for do codeAction of current line
  nmap <leader>cc <Plug>(coc-codeaction)
  " Fix autofix problem of current line
  nmap <leader>cq <Plug>(coc-fix-current)
  " Remap keys for gotos
  nmap <silent> gd <Plug>(coc-definition)
  nmap <silent> gy <Plug>(coc-type-definition)
  nmap <silent> gi <Plug>(coc-implementation)
  nmap <silent> gr <Plug>(coc-references)

  " coc-git
  nmap [g <Plug>(coc-git-prevchunk)
  nmap ]g <Plug>(coc-git-nextchunk)
  " show commit contains current position
  nmap <Leader>cgc <Plug>(coc-git-commit)
  " show chunk diff at current position
  nmap <Leader>cgi <Plug>(coc-git-chunkinfo)
  " show git status
  nnoremap <silent> <leader>cgs  :<C-u>CocList --normal gstatus<CR>
  nnoremap <Leader>cgb :CocCommand git.browserOpen<CR>
  nnoremap <Leader>cgB :CocCommand git.copyUrl<CR>
  nnoremap <Leader>cgd :CocCommand git.diffCached<CR>
  nnoremap <Leader>cgf :CocCommand git.foldUnchanged<CR>
  nnoremap <Leader>cgt :CocCommand git.chunkStage<CR>
  nnoremap <Leader>cgu :CocCommand git.chunkUndo<CR>

  " Coc toggles
  nnoremap <Leader>ctg :<C-u>CocCommand git.toggleGutters<Cr>
  nnoremap <Leader>cts :<C-u>CocCommand cSpell.toggleEnableSpellChecker<Cr>

  " Use K for show documentation in float window
  " nnoremap <silent> K :call CocActionAsync('doHover')<CR>

  " Use K to show documentation in preview window.
  nnoremap <silent> K :call <SID>show_documentation()<CR>

  function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
      execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
      call CocActionAsync('doHover')
    else
      execute '!' . &keywordprg . " " . expand('<cword>')
    endif
  endfunction

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  " Remap <C-f> and <C-b> for scroll float windows/popups.
  if has('nvim-0.4.0') || has('patch-8.2.0750')
    nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
    inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
    inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
    vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
    vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  endif

  " multiple cursors
  nmap <silent> <C-c> <Plug>(coc-cursors-position)
  " use normal command like `<leader>xi(`
  nmap <leader>cx <Plug>(coc-cursors-operator)

  nmap <expr> <silent> <C-s> <SID>select_current_word()
  function! s:select_current_word()
    if !get(g:, 'coc_cursors_activated', 0)
      return "\<Plug>(coc-cursors-word)"
    endif
    " Adjusted for vim-asterisk plugin
    return "*\<Plug>(coc-cursors-word):nohlsearch\<CR>"
  endfunc

  nnoremap <silent> <leader>cs :<C-u>call feedkeys(':CocSearch<Space>','t')<CR>
  nnoremap <silent> <leader>cS :<C-u>call feedkeys(':CocSearch -w<Space>','t')<CR>

  nmap <leader>cr <Plug>(coc-refactor)

  " Movement within 'ins-completion-menu'
  imap <expr><C-j> pumvisible() ? "\<Down>" : "\<C-j>"
  imap <expr><C-k> pumvisible() ? "\<Up>" : "<C-k>"

  " Scroll pages in menu
  " inoremap <expr><C-f> pumvisible() ? "\<PageDown>" : "\<Right>" a
  " inoremap <expr><C-b> pumvisible() ? "\<PageUp>" : "\<Left>"
  " imap     <expr><C-d> pumvisible() ? "\<PageDown>" : "\<C-d>"
  " imap     <expr><C-u> pumvisible() ? "\<PageUp>" : "\<C-u>"

  " nnoremap <expr><C-n> coc#util#has_float() ?
  "     \ coc#util#float_scrollable() ?
  "     \ coc#util#float_scroll(1)
  "     \ : ""
  "     \ : "\<C-n>"
  " nnoremap <expr><C-p> coc#util#has_float() ?
  "     \ coc#util#float_scrollable() ?
  "     \ coc#util#float_scroll(0)
  "     \ : ""
  "     \ : "\<C-p>"

  " Map function and class text objects
  " NOTE: Requires 'textDocument.documentSymbol' support from the language server.
  xmap if <Plug>(coc-funcobj-i)
  omap if <Plug>(coc-funcobj-i)
  xmap af <Plug>(coc-funcobj-a)
  omap af <Plug>(coc-funcobj-a)
  xmap ic <Plug>(coc-classobj-i)
  omap ic <Plug>(coc-classobj-i)
  xmap ac <Plug>(coc-classobj-a)
  omap ac <Plug>(coc-classobj-a)

  " Use <c-space> to trigger completion.
  if has('nvim')
    inoremap <silent><expr> <c-space> coc#refresh()
  else
    inoremap <silent><expr> <c-@> coc#refresh()
  endif

  if s:enable_whichkey
    let g:which_key_gmap['d'] = 'Go to definition'
    let g:which_key_gmap['i'] = 'Go to implementation'
    let g:which_key_gmap['r'] = 'Go to reference'
    let g:which_key_gmap['y'] = 'Go to type definition'
  endif
endif

if dein#tap('vim-clap')
  nnoremap <silent> <Leader>fd: :<C-u>Clap command_history<CR>
  nnoremap <silent> <Leader>fdc :<C-u>Clap colors<CR>
  nnoremap <silent> <Leader>fdb :<C-u>Clap buffers<CR>
  nnoremap <silent> <Leader>fdr :<C-u>Clap grep<CR>
  nnoremap <silent> <Leader>fdR :<C-u>Clap grep %:p:h<CR>
  nnoremap <silent> <Leader>fds :<C-u>Clap sessions<CR>
  nnoremap <silent> <Leader>fdm :<C-u>Clap marks<CR>
  nnoremap <silent> <Leader>fdf :<C-u>Clap files ++finder=rg --files<cr>
  nnoremap <silent> <Leader>fdF :<C-u>Clap files ++finder=rg --hidden --files<cr>
  nnoremap <silent> <Leader>fdg :<C-u>Clap gfiles<CR>
  nnoremap <silent> <Leader>fdw :<C-u>Clap grep ++query=<cword><cr>
  nnoremap <silent> <Leader>fdh :<C-u>Clap history<CR>
  nnoremap <silent> <Leader>fdW :<C-u>Clap windows<CR>
  nnoremap <silent> <Leader>fdl :<C-u>Clap loclist<CR>
  nnoremap <silent> <Leader>fdu :<C-u>Clap git_diff_files<CR>
  nnoremap <silent> <Leader>fdv :<C-u>Clap grep2 ++query=@visual<CR>
  vnoremap <silent> <Leader>fdv <Esc>:<C-u>Clap grep2 ++query=@visual<CR>
  nnoremap <silent> <Leader>fdp :<C-u>Clap personalconf<CR>
  "like emacs counsel-find-file
  nnoremap <silent> <C-x><C-f> :<C-u>Clap filer<CR>

  autocmd user_events FileType clap_input call s:clap_mappings()

  function! s:clap_mappings()
    nnoremap <silent> <buffer> <nowait> <Space> :call clap#handler#tab_action()<CR>
    nnoremap <silent> <buffer> <C-j> :<C-u>call clap#navigation#linewise('down')<CR>
    nnoremap <silent> <buffer> <C-k> :<C-u>call clap#navigation#linewise('up')<CR>
    nnoremap <silent> <buffer> <C-n> :<C-u>call clap#navigation#linewise('down')<CR>
    nnoremap <silent> <buffer> <C-p> :<C-u>call clap#navigation#linewise('up')<CR>
    nnoremap <silent> <buffer> <C-f> :<c-u>call clap#navigation#scroll('down')<CR>
    nnoremap <silent> <buffer> <C-b> :<c-u>call clap#navigation#scroll('up')<CR>

    nnoremap <silent> <buffer> q     :<c-u>call clap#handler#exit()<CR>
    nnoremap <silent> <buffer> <Esc> :call clap#handler#exit()<CR>
    inoremap <silent> <buffer> <Esc> <C-R>=clap#navigation#linewise('down')<CR><C-R>=clap#navigation#linewise('up')<CR><Esc>
    inoremap <silent> <buffer> jj    <C-R>=clap#navigation#linewise('down')<CR><C-R>=clap#navigation#linewise('up')<CR><Esc>
  endfunction

  if s:enable_whichkey
    let g:which_key_map['f']['d'] = {
          \ 'name' : '+finder',
          \ ':' : 'Find on command history',
          \ 'b' : 'Find on buffers',
          \ 'c' : 'Find colorscheme',
          \ 'f' : 'Find files on directory',
          \ 'F' : 'Find files on directory (includes hidden files)',
          \ 'g' : 'Find git files',
          \ 'h' : 'Find on history',
          \ 'l' : 'Find on locationlist',
          \ 'm' : 'Find files with marks',
          \ 'o' : 'Find old files',
          \ 'p' : 'Find personal configurations',
          \ 'r' : 'Find word with grep2',
          \ 'R' : 'Find word relative to current file directory',
          \ 's' : 'Find sessions',
          \ 'u' : 'Find git diff files',
          \ 'v' : 'Find last visual selection with Grep',
          \ 'w' : 'Find word undercursor with Grep',
          \ }
  endif
endif

if dein#tap('telescope.nvim')
  " Find files using Telescope command-line sugar.
  nnoremap <leader>fdb <cmd>Telescope buffers<cr>
  nnoremap <leader>fdc <cmd>Telescope colorscheme<cr>
  nnoremap <leader>fdf <cmd>Telescope find_files<cr>
  nnoremap <leader>fdF <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files prompt_prefix=🔍<cr>
  nnoremap <leader>fdd <cmd>Telescope file_browser<cr>
  nnoremap <leader>fdr <cmd>Telescope live_grep<cr>
  nnoremap <leader>fdh <cmd>Telescope help_tags<cr>
  nnoremap <leader>fdj <cmd>Telescope jumplist<cr>
  nnoremap <leader>fdm <cmd>Telescope marks<cr>
  nnoremap <leader>fdo <cmd>Telescope oldfiles<cr>
  nnoremap <leader>fdw <cmd>Telescope grep_string<cr>
  nnoremap <leader>fdgb <cmd>Telescope git_branch<cr>
  nnoremap <leader>fdgc <cmd>Telescope git_commits<cr>
  nnoremap <leader>fdgf <cmd>Telescope git_files<cr>
  nnoremap <leader>fdgs <cmd>Telescope git_status<cr>

  if s:enable_whichkey
    let g:which_key_map['f']['d'] = {
          \ 'name' : '+finder',
          \ 'b' : 'Find buffers',
          \ 'c' : 'Find colorscheme',
          \ 'd' : 'File browser',
          \ 'f' : 'Find files',
          \ 'F' : 'Find hidden files',
          \ 'g' : {
              \ 'name' : '+git',
              \ 'b' : 'Find git branch',
              \ 'c' : 'Find git commits',
              \ 'f' : 'Find git files',
              \ 's' : 'Find git files with changes',
            \ },
          \ 'h' : 'Find help tags',
          \ 'j' : 'Find jumplist',
          \ 'm' : 'Find files with marks',
          \ 'o' : 'Find old files',
          \ 'r' : 'Find string live grep',
          \ 'w' : 'Find string undercursor',
          \ }
  endif
endif

if dein#tap('codi.vim')
  nnoremap <Leader>icc :<C-u>Codi!!<CR>
  nnoremap <Leader>icu :<C-u>CodiUpdate<CR>
  if s:enable_whichkey
    let g:which_key_map['i']['c'] = {
          \ 'name' : '+codi (interactive scratchpad)',
          \ 'c' : 'Codi toggle',
          \ 'u' : 'Update Codi output',
          \ }
  endif
endif

if dein#tap('vimspector')
  " Close all debugging window
  nmap <Leader>dvE :call feedkeys(':VimspectorEval<Space><Tab>','t')<CR>
  nmap <Leader>dvw :call feedkeys(':VimspectorWatch<Space><Tab>','t')<CR>
  nmap <Leader>dvs :call feedkeys(':VimspectorShowOutput<Space><Tab>','t')<CR>
  nmap <Leader>dvbb <Plug>VimspectorToggleBreakpoint
  nmap <Leader>dvbc <Plug>VimspectorToggleConditionalBreakpoint
  nmap <Leader>dvbf <Plug>VimspectorAddFunctionBreakpoint
  nmap <Leader>dvc <Plug>VimspectorRunToCursor
  nmap <Leader>dve <Plug>VimspectorBalloonEval
  xmap <Leader>dve <Plug>VimspectorBalloonEval
  nmap <Leader>dvh <Plug>VimspectorContinue
  nmap <Leader>dvj <Plug>VimspectorStepOver
  nmap <Leader>dvk <Plug>VimspectorStepOut
  nmap <Leader>dvJ <Plug>VimspectorDownFrame
  nmap <Leader>dvK <Plug>VimspectorUpFrame
  nmap <Leader>dvl <Plug>VimspectorStepInto
  nmap <Leader>dvp <Plug>VimspectorPause
  nmap <Leader>dvq :VimspectorReset<CR>
  nmap <Leader>dvr <Plug>VimspectorRestart
  nmap <Leader>dvx <Plug>VimspectorStop

  nmap <Leader><F11> <Plug>VimspectorUpFrame
  nmap <Leader><F12> <Plug>VimspectorDownFrame

  if s:enable_whichkey
    let g:which_key_map['<F5>'] = 'Vimspector launch'
    let g:which_key_map['<F8>'] = 'Vimspector run to cursor'
    let g:which_key_map['<F9>'] = 'Vimspector toggle conditional break'
    let g:which_key_map['<F11>'] = 'Vimspector frame up'
    let g:which_key_map['<F12>'] = 'Vimspector frame down'
    let g:which_key_map['d']['v'] = {
         \ 'name' : '+vimspector',
            \ 'b' : {
                  \ 'name' : '+breakpoints',
                  \ 'b' : 'Toggle line breakpoint under current line',
                  \ 'c' : 'Toggle conditional line breakpoint under current line',
                  \ 'f' : 'Add a function breakpoint for the expression under cursor',
                \ },
            \ 'c' : 'Run to cursor',
            \ 'e' : 'Evaluate variable under cursor',
            \ 'E' : 'Evaluate variable <var-name>',
            \ 'h' : 'Start Vimspector (continue)',
            \ 'j' : 'Step over (next)',
            \ 'J' : 'Frame down',
            \ 'k' : 'Step out (finish)',
            \ 'K' : 'Frame up',
            \ 'l' : 'Step into (step)',
            \ 'p' : 'Pause debuggee',
            \ 'r' : 'Restart debugging',
            \ 's' : 'Show output <category>',
            \ 'q' : 'Close vimspector and reset',
            \ 'x' : 'Stop debugging',
            \ 'w' : 'Watch variable <var-name>',
         \ }
  endif
endif

if dein#tap('vim-easy-align')
  " Start interactive EasyAlign in visual mode
  xnoremap <Leader>raa :EasyAlign<CR>
  " Start interactive EasyAlign for a motion/text object
  nnoremap <Leader>raa :EasyAlign<CR>
  " Start Live-interactive EasyAlign in visual mode
  xnoremap <Leader>rAA :LiveEasyAlign<CR>
  " Start Live-interactive EasyAlign for a motion/text object<CR>
  nnoremap <Leader>rAA :LiveEasyAlign<CR>

  if s:enable_whichkey
    let g:which_key_map['r']['a'] = {
          \ 'name' : '+easyalign',
          \ 'a' : 'Start easyalign',
          \ 'a<CR><Delim>' : 'Around 1st delimiter',
          \ 'a<CR>3<Delim>' : 'Around 3rd delimiter',
          \ 'a<CR>-<Delim>' : 'Around the last delimiter',
          \ 'a<CR>-2<Delim>' : 'Around the 2nd last delimiter',
          \ 'a<CR>*<Delim>' : 'Around all <Delim>',
          \ 'a<CR>:' : 'Around 1st colon ( key: value )',
          \ 'a<CR><Right>:' : 'Around 1st ( key : value )',
          \ 'a<CR>**<Delim>' : 'Left-right alternating around <Delim>',
          \ 'a<CR><CR>**<Delim>' : 'Right-left alternating around <Delim>',
          \ 'a<CR><CR>Delim>' : 'Right alignment aroung 1st <Delim>',
          \ }
    let g:which_key_map['r']['A'] = {
          \ 'name' : '+easyalign-live',
          \ 'A' : 'Start easyalign-live',
          \ 'A<CR><Delim>' : 'Around 1st delimiter',
          \ 'A<CR>3<Delim>' : 'Around 3rd delimiter',
          \ 'A<CR>-<Delim>' : 'Around the last delimiter',
          \ 'A<CR>-2<Delim>' : 'Around the 2nd last delimiter',
          \ 'A<CR>*<Delim>' : 'Around all <Delim>',
          \ 'A<CR>:' : 'Around 1st colon ( key: value )',
          \ 'A<CR><Right>:' : 'Around 1st ( key : value )',
          \ 'A<CR>**<Delim>' : 'Left-right alternating around <Delim>',
          \ 'A<CR><CR>**<Delim>' : 'Right-left alternating around <Delim>',
          \ 'a<CR><CR>Delim>' : 'Right alignment aroung 1st <Delim>',
          \ }
  endif
endif

if dein#tap('vim-mundo')
  nnoremap <silent> <Leader>ou :MundoToggle<CR>
  if s:enable_whichkey
    let g:which_key_map['o']['u'] = 'Undo tree toggle'
  endif
endif

if dein#tap('caw.vim')
  function! InitCaw() abort
    if ! (&l:modifiable && &buftype ==# '')
      silent! nunmap <buffer> gc
      silent! xunmap <buffer> gc
      silent! nunmap <buffer> gcc
      silent! xunmap <buffer> gcc
    else
      xmap <buffer> <Leader>// <Plug>(caw:hatpos:toggle)
      nmap <buffer> <Leader>// <Plug>(caw:hatpos:toggle)
      xmap <buffer> <Leader>/a <Plug>(caw:dollarpos:comment)
      nmap <buffer> <Leader>/a <Plug>(caw:dollarpos:comment)
      xmap <buffer> <Leader>/b <Plug>(caw:box:comment)
      nmap <buffer> <Leader>/b <Plug>(caw:box:comment)
      xmap <buffer> <Leader>/c <Plug>(caw:hatpos:comment)
      nmap <buffer> <Leader>/c <Plug>(caw:hatpos:comment)
      xmap <buffer> <Leader>/j <Plug>(caw:jump:comment-next)
      nmap <buffer> <Leader>/j <Plug>(caw:jump:comment-next)
      xmap <buffer> <Leader>/k <Plug>(caw:jump:comment-prev)
      nmap <buffer> <Leader>/k <Plug>(caw:jump:comment-prev)
      xmap <buffer> <Leader>/i <Plug>(caw:zeropos:comment)
      nmap <buffer> <Leader>/i <Plug>(caw:zeropos:comment)
      xmap <buffer> <Leader>/w <Plug>(caw:wrap:toggle)
      nmap <buffer> <Leader>/w <Plug>(caw:wrap:toggle)
      nmap <buffer> gc <Plug>(caw:prefix)
      xmap <buffer> gc <Plug>(caw:prefix)
      nmap <buffer> gcc <Plug>(caw:hatpos:toggle:operator)
      xmap <buffer> gcc <Plug>(caw:hatpos:toggle)
    endif
  endfunction
  autocmd FileType * call InitCaw()
  call InitCaw()

  if s:enable_whichkey
    let g:which_key_map['/'] = {
          \ 'name' : '+commenter',
          \ '/' : 'Comment toggle',
          \ 'a' : 'Comment line/selected end',
          \ 'b' : 'Comment box',
          \ 'c' : 'Comment line/selected',
          \ 'i' : 'Comment line/selected beginning',
          \ 'j' : 'Jump next comment',
          \ 'k' : 'Jump Prev comment',
          \ 'w' : 'Comment wrap toggle',
          \ }
  endif
endif

if dein#tap('accelerated-jk')
  " Position-driven acceleration
  nmap j <Plug>(accelerated_jk_gj_position)
  nmap k <Plug>(accelerated_jk_gk_position)

  " " Time-driven acceleration (has problems with repeating macro)
  " nmap j <Plug>(accelerated_jk_gj)
  " nmap k <Plug>(accelerated_jk_gk)
endif

if dein#tap('goyo.vim')
  nnoremap <Leader>ig :Goyo<CR>
  if s:enable_whichkey
    let g:which_key_map['i']['g'] = 'Goyo toggle'
  endif
endif

if dein#tap('nvim-tree.lua')
  nnoremap <silent> <Leader>ee :NvimTreeToggle<CR>
  nnoremap <silent> <Leader>ef :NvimTreeFindFile<CR>
  nnoremap <silent> <Leader>er :NvimTreeRefresh<CR>

  if s:enable_whichkey
    let g:which_key_map['e']['e'] = 'Toggle explorer to current directory'
    let g:which_key_map['e']['r'] = 'Toggle explorer resume directory'
  endif
endif

if dein#tap('dashboard-nvim')
  nnoremap <silent> <leader>so :<C-u>Dashboard<CR>
  if s:enable_whichkey
    let g:which_key_map['s']['o'] = 'Dashboard open'
  endif
endif

if dein#tap('vim-quickrun')
  nnoremap <silent> <Localleader>r :QuickRun -mode n<CR>
  vnoremap <silent> <LocalLeader>r :QuickRun -mode v<CR>
endif

if dein#tap('vista.vim')
  nnoremap <silent><Leader>ovv :Vista!!<CR>
  nnoremap <silent><Leader>ovc :Vista finder clap<CR>
  nnoremap <silent><Leader>ovf :Vista focus<CR>
  nnoremap <silent><Leader>ovo :Vista<CR>
  nnoremap <silent><Leader>ovq :Vista!<CR>

  if s:enable_whichkey
    let g:which_key_map['o']['v'] = {
          \ 'name' : '+vista',
          \ 'v' : 'Vista toggle',
          \ 'c' : 'Vista finder clap',
          \ 'f' : 'Vista focus back and forth',
          \ 'o' : 'Vista open',
          \ 'q' : 'Vista close',
          \ }
  endif
endif

if dein#tap('tagbar')
  nnoremap <silent><Leader>ott :Tagbar<CR>

  if s:enable_whichkey
    let g:which_key_map['o']['t'] = {
          \ 'name' : '+tagbar',
          \ 't' : 'Tagbar toggle',
          \ }
  endif
endif

if dein#tap('vim-easymotion')
  nmap <Leader><Leader>r <Plug>(easymotion-repeat)
  nmap <Leader><Leader>s <Plug>(easymotion-s2)
  nmap <Leader><Leader>S <Plug>(easymotion-overwin-f2)
  nmap <Leader><Leader>e <Plug>(easymotion-e)
  nmap <Leader><Leader>E <Plug>(easymotion-ge)
  nmap <Leader><Leader>w <Plug>(easymotion-w)
  nmap <Leader><Leader>b <Plug>(easymotion-b)
  nmap <Leader><Leader>f <Plug>(easymotion-f2)
  nmap <Leader><Leader>F <Plug>(easymotion-F2)
  nmap <Leader><Leader>t <Plug>(easymotion-t2)
  nmap <Leader><Leader>T <Plug>(easymotion-T2)
  nmap <Leader><Leader>n <Plug>(easymotion-n)
  nmap <Leader><Leader>N <Plug>(easymotion-N)
  map <Leader><Leader>l <Plug>(easymotion-lineforward)
  map <Leader><Leader>j <Plug>(easymotion-j)
  map <Leader><Leader>k <Plug>(easymotion-k)
  map <Leader><Leader>h <Plug>(easymotion-linebackward)
  map  / <Plug>(easymotion-sn)
  omap / <Plug>(easymotion-tn)
  nmap <Leader><Leader>; <Plug>(easymotion-next)
  nmap <Leader><Leader>, <Plug>(easymotion-prev)

  if s:enable_whichkey
    let g:which_key_map[' '] = {
          \ 'name' : '+easymotion',
          \ ',' : 'Jump to previous last easymotion match',
          \ ';' : 'Jump to next last easymotion match',
          \ 'E' : 'Jump to the end of a word backward',
          \ 'F' : 'Jump to any char backward',
          \ 'N' : 'Jump to latest "/" or "?" match backward',
          \ 'S' : 'Bidrectional jump to any char on all windows',
          \ 'T' : 'Jump before any char backward',
          \ 'b' : 'Jump to beginning of a word backward',
          \ 'e' : 'Jump to the end of a word forward',
          \ 'f' : 'Jump to any char forward',
          \ 'h' : 'Jump to any char backward within cursor line',
          \ 'j' : 'Jump downwards at the same column',
          \ 'k' : 'Jump upwards at the same column',
          \ 'l' : 'Jump to any char forward within cursor line',
          \ 'n' : 'Jump to latest "/" or "?" match forward',
          \ 'r' : 'Repeat last motion',
          \ 's' : 'Bidrectional jump to any char',
          \ 't' : 'Jump before any char forward',
          \ 'w' : 'Jump to beginning of a word forward',
          \ }
  endif
endif

if dein#tap('vim-niceblock')
  silent! xmap I  <Plug>(niceblock-I)
  silent! xmap gI <Plug>(niceblock-gI)
  silent! xmap A  <Plug>(niceblock-A)
endif

if dein#tap('vim-sandwich')
  nmap <silent> sa <Plug>(operator-sandwich-add)
  xmap <silent> sa <Plug>(operator-sandwich-add)
  omap <silent> sa <Plug>(operator-sandwich-g@)
  nmap <silent> sd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
  xmap <silent> sd <Plug>(operator-sandwich-delete)
  nmap <silent> sr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
  xmap <silent> sr <Plug>(operator-sandwich-replace)
  nmap <silent> sdb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
  nmap <silent> srb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
  omap ib <Plug>(textobj-sandwich-auto-i)
  xmap ib <Plug>(textobj-sandwich-auto-i)
  omap ab <Plug>(textobj-sandwich-auto-a)
  xmap ab <Plug>(textobj-sandwich-auto-a)
  omap is <Plug>(textobj-sandwich-query-i)
  xmap is <Plug>(textobj-sandwich-query-i)
  omap as <Plug>(textobj-sandwich-query-a)
  xmap as <Plug>(textobj-sandwich-query-a)
endif

if dein#tap('sideways.vim')
  nnoremap <c-h> :SidewaysLeft<cr>
  nnoremap <c-l> :SidewaysRight<cr>
endif

if dein#tap('vim-zoom')
  nmap <silent> [Window]f <Plug>(zoom-toggle)
endif

if dein#tap('vim-maximizer')
  nmap <silent> [Window]z :MaximizerToggle<CR>
endif

if dein#tap('vim-rooter')
  nnoremap <Leader>frr :Rooter<CR>
endif

if dein#tap('golden_size')
  function! GoldenSizeToggle()
    if g:golden_size_off
      let g:golden_size_off = 0
      echom "Golden size on"
    else
      let g:golden_size_off = 1
      echom "Golden size off"
    endif
  endfunction
  nnoremap <LocalLeader>sr :<C-u>call GoldenSizeToggle()<CR>
endif

if dein#tap('markdown-preview.nvim')
  " Disable some mappings
  map <Plug> <Plug>Markdown_MoveToCurHeader
  map <Plug> <Plug>Markdown_OpenUrlUnderCursor

  nmap <Leader>lmo <Plug>MarkdownPreview
  nmap <Leader>lms <Plug>MarkdownPreviewStop
  nmap <Leader>lmt <Plug>MarkdownPreviewToggle

  if s:enable_whichkey
    let g:which_key_map['l']['o'] = 'Markdown preview'
    let g:which_key_map['l']['s'] = 'Markdown preview stop'
    let g:which_key_map['l']['t'] = 'Markdown preview toggle'
  endif
endif

if dein#tap('vim-markdown')
  nnoremap <Leader>lmit :<C-u>Toc<CR>
  nnoremap <Leader>lmiv :<C-u>Tocv<CR>
  nnoremap <Leader>lmih :<C-u>Toch<CR>

  if s:enable_whichkey
    let g:which_key_map['l']['m']['i'] = {
          \ 'name' : '+table-of-contents',
          \ 'h' : 'Table of contents horizontal',
          \ 't' : 'Table of contents',
          \ 'v' : 'Table of contents vertical',
          \ }
  endif
endif

if dein#tap('vimtex')
  if s:enable_whichkey
    let g:which_key_localmap['l'] = { 'name': '+vimtex' }
  endif
endif

if dein#tap('vimwiki')
  nmap <LocalLeader>WW  :<C-u>VimwikiUISelect<CR>
  nmap <LocalLeader>WI  :<C-u>VimwikiDiaryIndex<CR>
  nmap <LocalLeader>wh  :<C-u>Vimwiki2HTML<CR>
  nmap <LocalLeader>whh :<C-u>Vimwiki2HTMLBrowse<CR>
  nmap <LocalLeader>wH  :<C-u>VimwikiAll2HTML<CR>
  nmap <LocalLeader>wl  :<C-u>VimwikiGenerateLinks<CR>
  " Setup vim for vimwiki diary note taking
  function! DToday()
    exec "VimwikiMakeDiaryNote"
    setlocal laststatus=0 colorcolumn=0
  endfunction
  nmap <LocalLeader>wT :<C-u>call DToday()<CR>

  if s:enable_whichkey
    let g:which_key_localmap['w'] = {
          \ 'name' : '+vimwiki',
          \ 'd' : 'Vimwiki delete current page',
          \ 'h' : 'Vimwiki to html',
          \ 'hh' : 'Vimwiki to html browse',
          \ 'H' : 'Vimwiki all to html',
          \ 'i' : 'Vimwiki diary index',
          \ 'l' : 'Vimwiki generate links',
          \ 'L' : 'Vimwiki custom generate resources links',
          \ 'n' : 'Vimwiki go to',
          \ 'r' : 'Vimwiki rename link',
          \ 's' : 'Vimwiki UI select',
          \ 't' : 'Vimwiki index new tab',
          \ 'T' : 'Vimwiki create new diary for today',
          \ 'w' : 'Vimwiki index',
          \ ' ' : {
          \ 'name' : '+diary',
          \ 'i' : 'Vimwiki diary generate link',
          \ 'm' : 'Vimwiki diary tomorrow',
          \ 't' : 'Vimwiki diary today',
          \ 'w' : 'Vimwiki diary note',
          \ 'y' : 'Vimwiki diary yesterday',
          \ },
          \ }

    let g:which_key_localmap['W'] = {
          \ 'name' : '+vimwiki-init',
          \ 'W' : 'Vimwiki UI select',
          \ 'I' : 'Vimwiki diary index',
          \ }
  endif
endif

if dein#tap('taskwiki')
  " Normal mode task commands
  nnoremap <LocalLeader>ta :TaskWikiAnnotate<CR>
  nnoremap <LocalLeader>tcp :TaskWikiChooseProject<CR>
  nnoremap <LocalLeader>tct :TaskWikiChooseTag<CR>
  nnoremap <LocalLeader>td :TaskWikiDone<CR>
  nnoremap <LocalLeader>tD :TaskWikiDelete<CR>
  nnoremap <LocalLeader>te :TaskWikiEdit<CR>
  nnoremap <LocalLeader>tg :TaskWikiGrid<CR>
  nnoremap <LocalLeader>ti :TaskWikiInfo<CR>
  nnoremap <LocalLeader>tl :TaskWikiLink<CR>
  nnoremap <LocalLeader>tm :TaskWikiMod<CR>
  nnoremap <LocalLeader>t+ :TaskWikiStart<CR>
  nnoremap <LocalLeader>t- :TaskWikiStop<CR>
  " Visual mode counter part task commands
  vnoremap <LocalLeader>ta :TaskWikiAnnotate<CR>
  vnoremap <LocalLeader>tcp :TaskWikiChooseProject<CR>
  vnoremap <LocalLeader>tct :TaskWikiChooseTag<CR>
  vnoremap <LocalLeader>td :TaskWikiDone<CR>
  vnoremap <LocalLeader>tD :TaskWikiDelete<CR>
  vnoremap <LocalLeader>te :TaskWikiEdit<CR>
  vnoremap <LocalLeader>tg :TaskWikiGrid<CR>
  vnoremap <LocalLeader>ti :TaskWikiInfo<CR>
  vnoremap <LocalLeader>tl :TaskWikiLink<CR>
  vnoremap <LocalLeader>tm :TaskWikiMod<CR>
  vnoremap <LocalLeader>t+ :TaskWikiStart<CR>
  vnoremap <LocalLeader>t- :TaskWikiStop<CR>

  " Other normal mode commands
  nnoremap <LocalLeader>tbl :TaskWikiBufferLoad<CR>
  nnoremap <LocalLeader>tbs :TaskWikiBufferSave<CR>
  nnoremap <LocalLeader>tbd :TaskWikiBurndownDaily<CR>
  nnoremap <LocalLeader>tbw :TaskWikiBurndownWeekly<CR>
  nnoremap <LocalLeader>tbm :TaskWikiBurndownMonthly<CR>
  nnoremap <LocalLeader>tC :TaskWikiCalendar<CR>
  nnoremap <LocalLeader>tGm :TaskWikiGhistoryMonthly<CR>
  nnoremap <LocalLeader>tGa :TaskWikiGhistoryAnnual<CR>
  nnoremap <LocalLeader>thm :TaskWikiHistoryMonthly<CR>
  nnoremap <LocalLeader>tha :TaskWikiHistoryAnnual<CR>
  nnoremap <LocalLeader>tp :TaskWikiProjects<CR>
  nnoremap <LocalLeader>ts :TaskWikiProjectsSummary<CR>
  nnoremap <LocalLeader>tS :TaskWikiStats<CR>
  nnoremap <LocalLeader>tt :TaskWikiTags<CR>

  " User defined functions
  nnoremap <LocalLeader>tu :call TaskWarriorServerUpdate('task sync', v:true)<CR>

  if s:enable_whichkey
    let g:which_key_localmap['t'] = {
          \ 'name' : '+taskwiki',
          \   'b' : { 'name' : '+taskwiki-burndown' },
          \   'c' : { 'name' : '+taskwiki-choose' },
          \   'h' : { 'name' : '+taskwiki-history' },
          \   'G' : { 'name' : '+taskwiki-ghistory' },
          \   'u' : ['call TaskWarriorServerUpdate()', 'Custom taskwiki server update'],
          \ }
  endif
endif

if dein#tap('vimux')
  " Prompt for a command to run
  nnoremap <Leader>vc :VimuxPromptCommand<CR>
  " Run last command executed by VimuxRunCommand
  nnoremap <Leader>vl :VimuxRunLastCommand<CR>
  " Inspect runner pane
  nnoremap <Leader>vi :VimuxInspectRunner<CR>
  " Close vim tmux runner opened by VimuxRunCommand
  nnoremap <Leader>vq :VimuxCloseRunner<CR>
  " Interrupt any command running in the runner pane
  nnoremap <Leader>vx :VimuxInterruptRunner<CR>
  " Zoom the runner pane (use <bind-key> z to restore runner pane)
  nnoremap <Leader>vf :VimuxZoomRunner<CR>
  if s:enable_whichkey
    let g:which_key_map['v'] = {
          \ 'name' : '+vimux',
          \ 'c' : 'Vimux prompt command',
          \ 'l' : 'Vimux run last command',
          \ 'i' : 'Vimux inspect runner',
          \ 'f' : 'Vimux zoom runner',
          \ 'q' : 'Vimux close runner',
          \ 'x' : 'Vimux interrupt runner',
          \ }
  endif
endif

if dein#tap('vim-tmux-navigator')
  nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
  nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
  nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
  nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
  nnoremap <silent> <M-\> :TmuxNavigatePrevious<cr>
endif

if dein#tap('vim-signature')
  let g:SignatureIncludeMarks = 'abcdefghijkloqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ'
  let g:SignatureMap = {
        \ 'Leader':            'm',
        \ 'ListBufferMarks':   'm/',
        \ 'ListBufferMarkers': 'm?',
        \ 'PlaceNextMark':     'm,',
        \ 'ToggleMarkAtLine':  'mm',
        \ 'PurgeMarksAtLine':  'm-',
        \ 'DeleteMark':        'dm',
        \ 'PurgeMarks':        'm<Space>',
        \ 'PurgeMarkers':      'm<BS>',
        \ 'GotoNextLineAlpha': "']",
        \ 'GotoPrevLineAlpha': "'[",
        \ 'GotoNextSpotAlpha': '`]',
        \ 'GotoPrevSpotAlpha': '`[',
        \ 'GotoNextLineByPos': "]'",
        \ 'GotoPrevLineByPos': "['",
        \ 'GotoNextSpotByPos': 'mn',
        \ 'GotoPrevSpotByPos': 'mp',
        \ 'GotoNextMarker':    ']-',
        \ 'GotoPrevMarker':    '[-',
        \ 'GotoNextMarkerAny': ']=',
        \ 'GotoPrevMarkerAny': '[=',
        \ }
endif

if dein#tap('open-browser.vim')
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)

  if s:enable_whichkey
    let g:which_key_gmap['x'] = 'Open in browser'
  endif
endif

if dein#tap('gina.vim')
  nnoremap <silent> <Leader>ga :Gina add %:p<CR>
  nnoremap <silent> <Leader>gA :Gina add .<CR>
  nnoremap <silent> <leader>gb :Gina blame --width=40<CR>
  nnoremap <silent> <Leader>gc :Gina commit<CR>
  nnoremap <silent> <leader>gd :Gina compare<CR>
  nnoremap <silent> <Leader>gF :Gina! fetch<CR>
  nnoremap <silent> <Leader>gl :Gina log --graph --all<CR>
  nnoremap <silent> <leader>go :,Gina browse :<CR>
  vnoremap <silent> <leader>go :Gina browse :<CR>
  nnoremap <silent> <Leader>gp :Gina! push<CR>
  nnoremap <silent> <leader>gs :Gina status -s -b<CR>

  if s:enable_whichkey
    let g:which_key_map['g']['a'] = 'Stage buffer'
    let g:which_key_map['g']['A'] = 'Stage all changes'
    let g:which_key_map['g']['b'] = 'Open git blame'
    let g:which_key_map['g']['c'] = 'Commit staged changes'
    let g:which_key_map['g']['d'] = 'Diff buffer'
    let g:which_key_map['g']['F'] = 'Fetch remote'
    let g:which_key_map['g']['l'] = 'Display git log'
    let g:which_key_map['g']['o'] = 'Open repo in browser'
    let g:which_key_map['g']['p'] = 'Push commits'
    let g:which_key_map['g']['s'] = 'Display git status'
  endif
endif

if dein#tap('vim-gitgutter')
  nmap ]g <Plug>(GitGutterNextHunk)
  nmap [g <Plug>(GitGutterPrevHunk)
  nmap gS <Plug>(GitGutterStageHunk)
  xmap gS <Plug>(GitGutterStageHunk)
  nmap gs <Plug>(GitGutterPreviewHunk)
  nmap <Leader>gr <Plug>(GitGutterUndoHunk)

  if s:enable_whichkey
    let g:which_key_rsbgmap['g'] = 'Go to next git changes hunk'
    let g:which_key_lsbgmap['g'] = 'Go to prev git changes hunk'
    let g:which_key_gmap['s'] = 'Preview git changes hunk'
    let g:which_key_gmap['S'] = 'Stage git changes hunk'
    let g:which_key_map['g']['r'] = 'Undo stage git changes hunk'
  endif
endif

if dein#tap('calendar.vim')
  nnoremap <LocalLeader>cc :Calendar -view=year -first_day=sunday<CR>
  nnoremap <LocalLeader>cd :Calendar -view=day<CR>
  nnoremap <LocalLeader>ch :Calendar -view=day -split=horizontal -position=below -height=12<CR>
  nnoremap <LocalLeader>cm :Calendar -view=monthly<CR>
  nnoremap <LocalLeader>ct :Calendar -view=clock<CR>
  nnoremap <LocalLeader>cv :Calendar -view=year -split=vertical -width=27 -first_day=sunday<CR>
  nnoremap <LocalLeader>cw :Calendar -view=week<CR>

  if s:enable_whichkey
    let g:which_key_localmap['c'] = {
          \ 'name' : '+calendar',
          \ 'c' : 'Calendar default',
          \ 'd' : 'Calendar daily',
          \ 'h' : 'Calendar horizontal daily',
          \ 'm' : 'Calendar monthly',
          \ 't' : 'Calendar clock',
          \ 'v' : 'Calendar vertical yearly',
          \ 'w' : 'Calendar weekly',
          \ }
  endif
endif

if dein#tap('nvim-colorizer.lua')
  nnoremap <LocalLeader>sc :<C-u>ColorizerToggle<CR>
  if s:enable_whichkey
    let g:which_key_localmap['s']['c'] = 'Color highlight toggle'
  endif
endif

if dein#tap('vim-abolish')
  nnoremap <Leader>rs :<C-u>Subvert//g<Left><Left>
  vnoremap <Leader>rs :Subvert//g<Left><Left>
  nnoremap <Leader>rS :<C-u>%Subvert//g<Left><Left>
  " Duplicate line and subvert. Uses "x register for yanking and pasting
  nnoremap <M-y> "xyy"xpV:Subvert//g<bar>norm`.$
        \ <Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
  inoremap <M-y> <ESC>"xyy"xpV:Subvert//g<bar>norm`.$
        \ <Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>

  if s:enable_whichkey
    let g:which_key_map['r']['s'] = 'Subvert line /{pat}/{sub}/[flags]'
    let g:which_key_map['r']['S'] = 'Subvert entire /{pat}/{sub}/[flags]'
  endif
endif

if dein#tap('far.vim')
  nnoremap <silent> <Leader>rfd  :Fardo<cr>
  nnoremap <silent> <Leader>rff  :Farf<cr>
  vnoremap <silent> <Leader>rff  :Farf<cr>
  nnoremap <silent> <Leader>rfl  :Refar<cr>
  vnoremap <silent> <Leader>rfl  :Refar<cr>
  nnoremap <silent> <Leader>rfr  :Farr<cr>
  vnoremap <silent> <Leader>rfr  :Farr<cr>
  nnoremap <silent> <Leader>rfu  :Farundo<cr>

  if s:enable_whichkey
    let g:which_key_map['r']['f'] = {
          \ 'name' : '+far',
          \ 'd' : 'Do (apply) find and replace',
          \ 'f' : 'Find',
          \ 'l' : 'Reexecute last far command',
          \ 'r' : 'Find and replace',
          \ 'u' : 'Undo find and replace',
          \ }
  endif
endif

if dein#tap('leetcode.vim')
  nnoremap <Leader>Ll :LeetCodeList<CR>
  nnoremap <Leader>Lt :LeetCodeTest<CR>
  nnoremap <Leader>Ls :LeetCodeSubmit<CR>
  nnoremap <Leader>Lu :LeetCodeSignIn<CR>

  if s:enable_whichkey
    let g:which_key_map['L'] = {
          \ 'name' : '+leetcode',
          \ 'l' : 'LeetCode list problems',
          \ 't' : 'LeetCode test solution',
          \ 's' : 'LeetCode submit solution',
          \ 'u' : 'LeetCode Sign in',
          \ }
  endif
endif

function! EliteModeToggle()
  if get(g:, 'elite_mode', 0) ==# 1
    if dein#tap('delimitMate') | exec 'silent! DelimitMateOn' | endif
    if dein#tap('coc.nvim')
      exec 'silent! CocEnable'
     endif
    echom "Elite mode off"
    let g:elite_mode=v:false
  else
    if dein#tap('delimitMate') | exec 'silent! DelimitMateOff' | endif
    if dein#tap('coc.nvim')
      exec 'silent! CocDisable'
    endif
    echom "Elite mode on"
    let g:elite_mode=v:true
  endif
endfunction

nnoremap <Leader>E :<C-u>EliteModeToggle<CR>

command! -nargs=0 EliteModeToggle call EliteModeToggle()
