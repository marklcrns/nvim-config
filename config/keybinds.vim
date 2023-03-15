" Plugin key settings
let s:enable_whichkey = dein#is_sourced('vim-which-key')

if s:enable_whichkey
  " Extra mappings
  nnoremap <silent> ?] :<c-u>silent! WhichKey ']'<CR>
  nnoremap <silent> ?[ :<c-u>silent! WhichKey '['<CR>
  nnoremap <silent> ?s :<c-u>silent! WhichKey 's'<CR>
  nnoremap <silent> ?d :<c-u>silent! WhichKey 'd'<CR>
  nnoremap <silent> ?g :<c-u>silent! WhichKey 'g'<CR>
endif

if dein#tap('dein.vim')
  nnoremap <silent> <Leader>ppu  :call dein#update()<CR>
  nnoremap <silent> <Leader>ppr  :call dein#recache_runtimepath()<CR>
  nnoremap <silent> <Leader>ppl  :echo dein#get_log()<CR>
  nnoremap <silent> <Leader>ppL  :echo dein#get_updates_log()<CR>
  nnoremap <silent> <Leader>ppd  :call map(dein#check_clean(), "delete(v:val, \"rf\")")<CR>

  if s:enable_whichkey
    let g:which_key_map['p']['p'] = {
          \ 'name' : '+plugin-manager',
          \ 'd' : 'Delete unused plugins',
          \ 'l' : 'Get log',
          \ 'L' : 'Get update log',
          \ 'r' : 'Recache runtimepath',
          \ 'u' : 'Update plugins',
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

if dein#tap('auto-session')
  nnoremap <Leader>sad <cmd>Autosession delete<cr>
  nnoremap <Leader>sar <cmd>RestoreSession<cr>
  nnoremap <Leader>sas <cmd>SaveSession<cr>

  if s:enable_whichkey
    let g:which_key_map['s']['a'] = {
          \ 'name' : '+auto-session',
          \ 'd' : 'Delete session',
          \ 'r' : 'Restore cwd session',
          \ 's' : 'Save cwd session',
          \ }
  endif
endif

if dein#tap('session-lens')
  nnoremap <Leader>sf <cmd>Telescope session-lens search_session<cr>

  if s:enable_whichkey
    let g:which_key_map['s']['f'] = 'Find session and load'
  endif
endif

if dein#tap('nvim-lspconfig')
  " DEPRECATED: Defined in nvim-treesitter-textobjects
  " nnoremap <silent> [d :lua vim.diagnostic.goto_prev()<CR>
  " nnoremap <silent> ]d :lua vim.diagnostic.goto_next()<CR>
  nnoremap <silent> gD :lua vim.lsp.buf.declaration()<CR>
  " nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
  nnoremap <silent> gi :lua vim.lsp.buf.implementation()<CR>
  nnoremap <silent> gr :lua vim.lsp.buf.references()<CR>
  nnoremap <silent> gt :lua vim.lsp.buf.type_definition()<CR>

  nnoremap <silent> <leader>cd :lua vim.diagnostic.setloclist()<CR>
  nnoremap <silent> <Leader>cll <cmd>LspInfo<CR>
  nnoremap <silent> <Leader>cli <cmd>LspInstall<CR>

  if s:enable_whichkey
    let g:which_key_map['c']['l'] = {
          \ 'name' : '+lsp',
          \ 'l' : 'Lsp info',
          \ 'i' : 'Lsp install',
          \ }

    let g:which_key_map['c']['d'] = 'Show diagnostics in locationlist'

    let g:which_key_map['x'] = 'Open diagnostic float'
    let g:which_key_map['X'] = 'Set location list'

    let g:which_key_gmap['d'] = 'LSP: go to definition'
    let g:which_key_gmap['D'] = 'LSP: go to declaration'
    let g:which_key_gmap['i'] = 'LSP: go to implementation'
    let g:which_key_gmap['r'] = 'LSP: go to references'
    let g:which_key_gmap['t'] = 'LSP: go to type definition'
  endif
endif

if dein#tap('null-ls.nvim')
  nnoremap <silent> <leader>cf :lua vim.lsp.buf.format()<CR>
  nnoremap <silent> <Leader>cln <cmd>NullLsInfo<CR>

  if s:enable_whichkey
    let g:which_key_map['c']['f'] = 'Code format'
    let g:which_key_map['c']['l']['n'] = 'Lsp info (null-ls)'
  endif
endif

if dein#tap('lspsaga.nvim')
  " NOTE: hover_doc is defined in nvim-ufo peekOrHover()
  " nnoremap <silent> K           <cmd>Lspsaga hover_doc<CR>
  nnoremap <silent> gd          <cmd>Lspsaga peek_definition<CR>
  nnoremap <silent> gD          <cmd>Lspsaga goto_definition<CR>
  nnoremap <silent> gt          <cmd>Lspsaga peek_type_definition<CR>
  nnoremap <silent> gT          <cmd>Lspsaga goto_type_definition<CR>
  nnoremap <silent> gf          <cmd>Lspsaga lsp_finder<CR>
  nnoremap <silent> <leader>ca  <cmd>Lspsaga code_action<CR>
  vnoremap <silent> <leader>ca  <cmd>Lspsaga range_code_action<CR>
  nnoremap <silent> <leader>cr  <cmd>Lspsaga rename ++project<CR>
  nnoremap <silent> <leader>ci  <cmd>Lspsaga incoming_calls<CR>
  nnoremap <silent> <leader>co  <cmd>Lspsaga outgoing_calls<CR>
  nnoremap <silent> <leader>cO  <cmd>Lspsaga outline<CR>
  nnoremap <silent> [e          <cmd>Lspsaga diagnostic_jump_prev<CR>
  nnoremap <silent> ]e          <cmd>Lspsaga diagnostic_jump_next<CR>
  nnoremap <silent> [E          <cmd>lua require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })<CR>
  nnoremap <silent> ]E          <cmd>lua require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })<CR>
  nnoremap <silent> <C-\>       <cmd>Lspsaga term_toggle<CR>

  if s:enable_whichkey
    let g:which_key_map['c']['a'] = 'LSP: Code action'
    let g:which_key_map['c']['r'] = 'LSP: rename'
    let g:which_key_map['c']['i'] = 'LSP: peak step out function call'
    let g:which_key_map['c']['o'] = 'LSP: peak step in function call'
    let g:which_key_map['c']['O'] = 'LSP: show code outline'

    let g:which_key_gmap['d'] = 'LSP: peek definition'
    let g:which_key_gmap['D'] = 'LSP: go to definition'
    let g:which_key_gmap['t'] = 'LSP: peek type definition'
    let g:which_key_gmap['T'] = 'LSP: go to type definition'
    let g:which_key_gmap['f'] = 'LSP: finder'

    let g:which_key_lsbmap['e'] = 'LSP: Diagnostic prev'
    let g:which_key_rsbmap['e'] = 'LSP: Diagnostic next'
    let g:which_key_lsbmap['E'] = 'LSP: Diagnostic prev error'
    let g:which_key_rsbmap['E'] = 'LSP: Diagnostic next error'
  endif
endif

if dein#tap('shade.nvim')
  if s:enable_whichkey
    let g:which_key_localmap['s']['d'] = 'Toggle dim inactive window'
  endif
endif

if dein#tap('tint.nvim')
  nnoremap <silent> <LocalLeader>sd :lua require("tint").toggle()<CR>

  if s:enable_whichkey
    let g:which_key_localmap['s']['d'] = 'Toggle dim inactive window'
  endif
endif

if dein#tap('toggle-lsp-diagnostics.nvim')
  nnoremap <LocalLeader>sldu <Plug>(toggle-lsp-diag-underline)
  nnoremap <LocalLeader>slds <Plug>(toggle-lsp-diag-signs)
  nnoremap <LocalLeader>sldv <Plug>(toggle-lsp-diag-vtext)
  nnoremap <LocalLeader>sldp <Plug>(toggle-lsp-diag-update_in_insert)
  nnoremap <LocalLeader>sldd <Plug>(toggle-lsp-diag)

  if s:enable_whichkey
    let g:which_key_localmap['s']['l'] = {
          \ 'name' : '+lsp-toggles',
          \ 'd' : {
                \ 'name' : '+diagnostics',
                    \ 'd' : 'Toggle LSP diagnostics',
                    \ 'p' : 'Toggle update in insert',
                    \ 's' : 'Toggle signs',
                    \ 'u' : 'Toggle underline',
                    \ 'v' : 'Toggle virtualtext',
                \ },
          \ }
  endif
endif

if dein#tap('nvim-dap')
  nnoremap <silent> <F5> <cmd>lua require('dap').continue()<CR>
  nnoremap <silent> <F10> <cmd>lua require('dap').step_over()<CR>
  nnoremap <silent> <F11> <cmd>lua require('dap').step_into()<CR>
  nnoremap <silent> <F12> <cmd>lua require('dap').step_out()<CR>
  nnoremap <silent> <Leader>db <cmd>lua require('dap').toggle_breakpoint()<CR>
  nnoremap <silent> <Leader>dc <cmd>lua require('dap').continue()<CR>
  nnoremap <silent> <Leader>dh <cmd>lua require('dapui').eval(vim.call('expand','<cword>'), {enter=true})<CR>
  nnoremap <silent> <Leader>dl <cmd>lua require('dap').run_last()<CR>
  nnoremap <silent> <Leader>di <cmd>lua require('dap').step_into()<CR>
  nnoremap <silent> <Leader>do <cmd>lua require('dap').step_out()<CR>
  nnoremap <silent> <Leader>dO <cmd>lua require('dap').step_over()<CR>
  nnoremap <silent> <Leader>dr <cmd>lua require('dap').repl.open()<CR>
  nnoremap <silent> <Leader>dq <cmd>lua require('dap').terminate()<CR>

  if s:enable_whichkey
    let g:which_key_map['d']['b'] = 'Toggle line breakpoint'
    let g:which_key_map['d']['c'] = 'Run/Continue <F5>'
    let g:which_key_map['d']['h'] = 'Evaluate word under cursor'
    let g:which_key_map['d']['l'] = 'Run last debug init'
    let g:which_key_map['d']['i'] = 'Step into <F11>'
    let g:which_key_map['d']['o'] = 'Step out <F12>'
    let g:which_key_map['d']['O'] = 'Step over <F10>'
    let g:which_key_map['d']['r'] = 'Open REPL'
    let g:which_key_map['d']['q'] = 'Terminate debuger'
  endif
endif

if dein#tap('nvim-dap-ui')
  nnoremap <silent> <Leader>dd <cmd>lua require('dapui').toggle()<CR>

  if s:enable_whichkey
    let g:which_key_map['d']['d'] = 'Toggle debugger UI'
  endif
endif

if dein#tap('telescope-dap.nvim')
  nnoremap <silent> <Leader>dfc <cmd>lua require'telescope'.extensions.dap.commands{}<CR>
  nnoremap <silent> <Leader>dfd <cmd>lua require'telescope'.extensions.dap.configurations{}<CR>
  nnoremap <silent> <Leader>dfb <cmd>lua require'telescope'.extensions.dap.list_breakpoints{}<CR>
  nnoremap <silent> <Leader>dfv <cmd>lua require'telescope'.extensions.dap.variables{}<CR>
  nnoremap <silent> <Leader>dff <cmd>lua require'telescope'.extensions.dap.frames{}<CR>

  if s:enable_whichkey
    let g:which_key_map['d']['f'] = {
          \ 'name' : '+telescope-dap',
          \ 'c' : 'Commands',
          \ 'd' : 'Configurations',
          \ 'b' : 'Breakpoints',
          \ 'v' : 'Variables',
          \ 'f' : 'Frames',
          \ }
  endif
endif

if dein#tap('symbols-outline.nvim')
  " nnoremap <silent> <leader>cO :SymbolsOutline<CR>

  if s:enable_whichkey
    let g:which_key_map['c']['O'] = 'Show code outline'
  endif
endif

if dein#tap('mason.nvim')
  nnoremap <silent> <leader>clm <cmd>Mason<CR>

  if s:enable_whichkey
    let g:which_key_map['c']['l']['m'] = 'Mason'
  endif
endif

if dein#tap('vim-smartq')
  nmap <silent> <Leader>fq <Plug>(smartq_this_save)
  nmap <silent> <Leader>wq <Plug>(smartq_close_splits)

  if s:enable_whichkey
    let g:which_key_map['f']['q'] = 'SmartQ Save'
    let g:which_key_map['w']['q'] = 'SmartQ Close all splits'
  endif
endif

if dein#tap('vim-eunuch')
  nmap <silent> <Leader>fS <cmd>SudoWrite<CR>
  nmap <silent> <Leader>fe <cmd>SudoEdit<CR>

  if s:enable_whichkey
    let g:which_key_map['f']['s'] = 'Save buffer as root'
    let g:which_key_map['f']['e'] = 'Edit buffer as root'
  endif
endif

if dein#tap('telescope.nvim')
  " Find files using Telescope command-line sugar.
  nnoremap <leader>fdb <cmd>Telescope buffers<cr>
  nnoremap <leader>fdc <cmd>Telescope colorscheme<cr>
  nnoremap <leader>fdf <cmd>Telescope find_files<cr>
  nnoremap <leader>fdF <cmd>Telescope find_files find_command=rg,--ignore,--hidden,--files<cr>
  nnoremap <leader>fdp <cmd>Telescope projects<cr>
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
          \ 'p' : 'Find from projects',
          \ 'r' : 'Find string live grep',
          \ 'w' : 'Find string undercursor',
          \ }
  endif
endif

if dein#tap('todo-comments.nvim')
  nnoremap <Leader>fdt <cmd>TodoTelescope<cr>
  nnoremap <LocalLeader>oqt <cmd>TodoQuickFix<cr>

  if s:enable_whichkey
    let g:which_key_map['f']['d']['t'] = "Find TODOs"
    let g:which_key_localmap['o']['q']['t'] = "Open TODOs in quickfix"
  endif
endif

if dein#tap('dial.nvim')
  nmap  <C-a>  <Plug>(dial-increment)
  nmap  <C-x>  <Plug>(dial-decrement)
  vmap  <C-a>  <Plug>(dial-increment)
  vmap  <C-x>  <Plug>(dial-decrement)
  vmap g<C-a> g<Plug>(dial-increment)
  vmap g<C-x> g<Plug>(dial-decrement)
endif

if dein#tap('minimap.vim')
  nnoremap <Leader>im <cmd>MinimapToggle<CR>
  if s:enable_whichkey
    let g:which_key_map['i']['m'] = 'Minimap Toggle'
  endif
endif

if dein#tap('diffview.nvim')
  nnoremap <Leader>idd :<C-u>call feedkeys(':DiffviewOpen<Space><Tab>','t')<CR>
  nnoremap <Leader>idf :DiffviewFileHistory %<CR>

  if s:enable_whichkey
    let g:which_key_map['i']['d']['d'] = 'Diff for git rev'
    let g:which_key_map['i']['d']['f'] = 'Diff for git file history'
  endif
endif

if dein#tap('linediff.vim')
  nnoremap <silent> <Leader>idl :Linediff<CR>
  vnoremap <silent> <Leader>idl :Linediff<CR>
  nnoremap <silent> <Leader>idL :LinediffReset<CR>
  if s:enable_whichkey
    let g:which_key_map['i']['d']['l'] = 'Diff visual line to another'
    let g:which_key_map['i']['d']['L'] = 'Reset visual line diff'
  endif
endif

if dein#tap('neogen')
  nnoremap <Leader>nc <cmd>lua require('neogen').generate({ type = 'class' })<CR><CR>
  nnoremap <Leader>nf <cmd>lua require('neogen').generate({ type = 'func' })<CR><CR>
  nnoremap <Leader>nt <cmd>lua require('neogen').generate({ type = 'type' })<CR><CR>
  nnoremap <Leader>np <cmd>lua require('neogen').generate({ type = 'file' })<CR><CR>
  nnoremap <Leader>nn <cmd>lua require('neogen').generate()<CR>

  if s:enable_whichkey
    let g:which_key_map['n'] = {
          \ 'name' : '+neogen',
          \ 'c' : 'Generate class annotation',
          \ 'f' : 'Generate function annotation',
          \ 'n' : 'Generate annotation',
          \ 't' : 'Generate type annotation',
          \ 'p' : 'Generate file annotation',
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
  nnoremap <silent> <Leader>iu :MundoToggle<CR>
  if s:enable_whichkey
    let g:which_key_map['i']['u'] = 'Undo tree toggle'
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

if dein#tap('SmoothCursor.nvim')
  nnoremap <LocalLeader>sm <cmd>SmoothCursorToggle<CR>

  if s:enable_whichkey
    let g:which_key_localmap['s']['m'] = 'Toggle SmoothCursor'
  endif
endif

if dein#tap('goyo.vim')
  nnoremap <Leader>ig :Goyo<CR>
  if s:enable_whichkey
    let g:which_key_map['i']['g'] = 'Goyo toggle'
  endif
endif

if dein#tap('zen-mode.nvim')
  nnoremap <Leader>iz <cmd>ZenMode<CR>
  if s:enable_whichkey
    let g:which_key_map['i']['z'] = 'ZenMode toggle'
  endif
endif

if dein#tap('nvim-tree.lua')
  nnoremap <silent> <Leader>ee :NvimTreeToggle<CR>
  nnoremap <silent> <Leader>ef :NvimTreeFindFile<CR>
  nnoremap <silent> <Leader>er :NvimTreeRefresh<CR>

  if s:enable_whichkey
    let g:which_key_map['e']['e'] = 'Toggle explorer to current directory'
    let g:which_key_map['e']['f'] = 'Find current buffer in explorer'
    let g:which_key_map['e']['r'] = 'Refresh file explorer'
  endif
endif

if dein#tap('neo-tree.nvim')
  nnoremap <silent> <Leader>ee :Neotree filesystem toggle<CR>
  nnoremap <silent> <Leader>el :Neotree filesystem toggle position=left<CR>
  nnoremap <silent> <Leader>er :Neotree filesystem toggle position=right<CR>
  nnoremap <silent> <Leader>ef :Neotree filesystem reveal<CR>
  nnoremap <silent> <Leader>eb :Neotree buffers<CR>
  nnoremap <silent> <Leader>eg :Neotree git_status<CR>

  if s:enable_whichkey
    let g:which_key_map['e']['e'] = 'Toggle explorer to current directory'
    let g:which_key_map['e']['l'] = 'Toggle explorer to current directory (left)'
    let g:which_key_map['e']['r'] = 'Toggle explorer to current directory (right)'
    let g:which_key_map['e']['f'] = 'Toggle explorer to current file'
    let g:which_key_map['e']['b'] = 'Toggle buffer explorer'
    let g:which_key_map['e']['g'] = 'Toggle git status explorer'
  endif
endif

if dein#tap('dashboard-nvim')
  nnoremap <silent> <leader>so :<C-u>Dashboard<CR>
  if s:enable_whichkey
    let g:which_key_map['s']['o'] = 'Dashboard open'
  endif
endif

if dein#tap('vim-quickrun')
  nnoremap <silent> <Localleader>rq :QuickRun -mode n<CR>
  vnoremap <silent> <LocalLeader>rq :QuickRun -mode v<CR>
  if s:enable_whichkey
    let g:which_key_localmap['r']['q'] = 'QuickRun'
  endif
endif

if dein#tap('sniprun')
  nnoremap <silent> <Localleader>rs :SnipRun<CR>
  vnoremap <silent> <LocalLeader>rs :SnipRun<CR>
  nnoremap <silent> <LocalLeader>rl :SnipLive<CR>
  nnoremap <silent> <LocalLeader>rr :SnipReset<CR>
  if s:enable_whichkey
    let g:which_key_localmap['r']['s'] = 'SnipRun'
    let g:which_key_localmap['r']['l'] = 'SnipLive'
    let g:which_key_localmap['r']['r'] = 'SnipReset'
  endif
endif

if dein#tap('vista.vim')
  nnoremap <silent><Leader>ivv :Vista!!<CR>
  nnoremap <silent><Leader>ivc :Vista finder clap<CR>
  nnoremap <silent><Leader>ivf :Vista focus<CR>
  nnoremap <silent><Leader>ivo :Vista<CR>
  nnoremap <silent><Leader>ivq :Vista!<CR>

  if s:enable_whichkey
    let g:which_key_map['i']['v'] = {
          \ 'name' : '+vista',
          \ 'v' : 'Vista toggle',
          \ 'c' : 'Vista finder clap',
          \ 'f' : 'Vista focus back and forth',
          \ 'o' : 'Vista open',
          \ 'q' : 'Vista close',
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

if dein#tap('leap.nvim')
  nnoremap <silent> [Window]f :lua leap_to_window()<CR>
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

if dein#tap('vim-matchup')
  nnoremap <LocalLeader>sm :<C-R>=exists("g:matchup_matchparen_enabled") ? ( (g:matchup_matchparen_enabled == 1) ? 'NoMatchParen': 'DoMatchParen'): 'DoMatchParen'<CR><CR>

  if s:enable_whichkey
    let g:which_key_localmap['s']['m'] = 'Toggle matchup highlight'
  endif
endif

if dein#tap('nvim-ufo')
  if s:enable_whichkey
    let g:which_key_localmap['s']['r'] = 'Toggle Auto-resize'
  endif
endif

if dein#tap('nvim-treesitter-textobjects')
  if s:enable_whichkey
    let g:which_key_rsbmap['a'] = 'LSP: Go to next assignment'
    let g:which_key_lsbmap['a'] = 'LSP: Go to previous assignment'
    let g:which_key_rsbmap['f'] = 'LSP: Go to next function'
    let g:which_key_lsbmap['f'] = 'LSP: Go to previous function'
    let g:which_key_rsbmap['F'] = 'LSP: Swap with next function'
    let g:which_key_lsbmap['F'] = 'LSP: Swap with previous function'
    let g:which_key_rsbmap['n'] = 'LSP: Go to next number'
    let g:which_key_lsbmap['n'] = 'LSP: Go to previous number'
    let g:which_key_rsbmap['p'] = 'LSP: Go to next parameter'
    let g:which_key_lsbmap['p'] = 'LSP: Go to previous parameter'
    let g:which_key_rsbmap['P'] = 'LSP: Swap with next parameter'
    let g:which_key_lsbmap['P'] = 'LSP: Swap with previous parameter'
    let g:which_key_rsbmap['i'] = 'LSP: Go to next conditional'
    let g:which_key_lsbmap['i'] = 'LSP: Go to previous conditional'
    let g:which_key_rsbmap['I'] = 'LSP: Swap with next conditional'
    let g:which_key_lsbmap['I'] = 'LSP: Swap with previous conditional'
    let g:which_key_rsbmap['o'] = 'LSP: Go to next loop'
    let g:which_key_lsbmap['o'] = 'LSP: Go to previous loop'
    let g:which_key_rsbmap['O'] = 'LSP: Swap with next loop'
    let g:which_key_lsbmap['O'] = 'LSP: Swap with previous loop'
    let g:which_key_rsbmap['s'] = 'LSP: Go to next scope'
    let g:which_key_lsbmap['s'] = 'LSP: Go to previous scope'
    let g:which_key_rsbmap[']'] = 'LSP: Go to next class'
    let g:which_key_rsbmap['['] = 'LSP: Go to next inner class'
    let g:which_key_rsbmap['}'] = 'LSP: Go to next block'
    let g:which_key_lsbmap['['] = 'LSP: Go to previous class'
    let g:which_key_lsbmap[']'] = 'LSP: Go to previous inner class'
    let g:which_key_lsbmap['{'] = 'LSP: Go to previous block'
  endif
endif

if dein#tap('splitjoin.vim')
  nnoremap <silent> <Leader><c-j> <cmd>SplitjoinJoin<cr>
  nnoremap <silent> <Leader><c-k> <cmd>SplitjoinSplit<cr>
  if s:enable_whichkey
    let g:which_key_map['<C-J>'] = 'Splitjoin Join'
    let g:which_key_map['<C-K>'] = 'Splitjoin Split'
  endif
endif

if dein#tap('treesj')
  nnoremap <silent> <Leader>cs <cmd>lua require('treesj').toggle({ split = { recursive = true } })<cr>
  if s:enable_whichkey
    let g:which_key_map['c']['s'] = 'Toggle split/join'
  endif
endif

if dein#tap('project.nvim')
  nnoremap <Leader>frr :ProjectRoot<CR>

  if s:enable_whichkey
    let g:which_key_map['f']['r']['r'] = 'Change to current buffer directory'
  endif
endif

if dein#tap('focus.nvim')
  nnoremap <LocalLeader>sr <cmd>FocusToggle<CR>
  nnoremap <silent> [Window]z <cmd>FocusMaxOrEqual<CR>

  if s:enable_whichkey
    let g:which_key_localmap['s']['r'] = 'Toggle Auto-resize'
  endif
endif

if dein#tap('winshift.nvim')
  nnoremap <C-W>H     :WinShift left<CR>
  nnoremap <C-W>J     :WinShift down<CR>
  nnoremap <C-W>K     :WinShift up<CR>
  nnoremap <C-W>L     :WinShift right<CR>
  nnoremap <C-W>m     :WinShift swap<CR>
  nnoremap <C-W><C-M> :WinShift<CR>
endif

if dein#tap('vim-choosewin')
  nmap <C-W>f <Plug>(choosewin)
endif

if dein#tap('nvim-FeMaco.lua')
  nnoremap <Leader>lmf <cmd>FeMaco<CR>

  if s:enable_whichkey
    let g:which_key_map['l']['m']['f'] = 'Edit code fence with lsp under cursor'
  endif
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

if dein#tap('neorg')
  nmap <LocalLeader>nw :<C-u>call feedkeys(':Neorg workspace<Space><Tab>','t')<CR>
  nmap <LocalLeader>ns :<C-u>Neorg toc split<CR>
  if s:enable_whichkey
    let g:which_key_localmap['n'] = { 'name': '+neorg' }
    let g:which_key_localmap['n']['m'] = { 'name': '+mode-select' }
    let g:which_key_localmap['n']['n'] = { 'name': '+create' }
    let g:which_key_localmap['n']['t'] = { 'name': '+tree-sitter' }
    let g:which_key_localmap['n']['s'] = "TOC split"
    let g:which_key_localmap['n']['w'] = "Open Workspace"
  endif
endif

if dein#tap('mind.nvim')
  nnoremap <LocalLeader>mm <cmd>MindOpenMain<CR>
  nnoremap <LocalLeader>mp <cmd>MindOpenProject<CR>
  nnoremap <LocalLeader>ms <cmd>MindOpenSmartProject<CR>
  nnoremap <LocalLeader>mr <cmd>MindReloadState<CR>
  nnoremap <LocalLeader>mq <cmd>MindClose<CR>
  if s:enable_whichkey
    let g:which_key_localmap['m'] = {
          \ 'name' : '+mind',
          \ 'm' : 'Open main',
          \ 'p' : 'Open project',
          \ 's' : 'Open smart project',
          \ 'r' : 'Reload mind state',
          \ 'q' : 'Quit mind',
          \ }
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
  nnoremap <LocalLeader>tL :TaskWikiBufferLoad<CR>
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
  if s:enable_whichkey
    let g:which_key_rsbmap['-'] = 'Go next marker'
    let g:which_key_lsbmap['-'] = 'Go next marker'
  endif
endif

if dein#tap('open-browser.vim')
  nmap gx <Plug>(openbrowser-smart-search)
  vmap gx <Plug>(openbrowser-smart-search)

  if s:enable_whichkey
    let g:which_key_gmap['x'] = 'Open in browser'
  endif
endif

if dein#tap('text-case.nvim')
  nnoremap <silent> gau :lua require('textcase').current_word('to_upper_case')<CR>
  nnoremap <silent> gal :lua require('textcase').current_word('to_lower_case')<CR>
  nnoremap <silent> gas :lua require('textcase').current_word('to_snake_case')<CR>
  nnoremap <silent> gah :lua require('textcase').current_word('to_dash_case')<CR>
  nnoremap <silent> gan :lua require('textcase').current_word('to_constant_case')<CR>
  nnoremap <silent> gad :lua require('textcase').current_word('to_dot_case')<CR>
  nnoremap <silent> gaa :lua require('textcase').current_word('to_phrase_case')<CR>
  nnoremap <silent> gac :lua require('textcase').current_word('to_camel_case')<CR>
  nnoremap <silent> gap :lua require('textcase').current_word('to_pascal_case')<CR>
  nnoremap <silent> gat :lua require('textcase').current_word('to_title_case')<CR>
  nnoremap <silent> gaf :lua require('textcase').current_word('to_path_case')<CR>

  nnoremap <silent> gaU :lua require('textcase').lsp_rename('to_upper_case')<CR>
  nnoremap <silent> gaL :lua require('textcase').lsp_rename('to_lower_case')<CR>
  nnoremap <silent> gaS :lua require('textcase').lsp_rename('to_snake_case')<CR>
  nnoremap <silent> gaH :lua require('textcase').lsp_rename('to_dash_case')<CR>
  nnoremap <silent> gaN :lua require('textcase').lsp_rename('to_constant_case')<CR>
  nnoremap <silent> gaD :lua require('textcase').lsp_rename('to_dot_case')<CR>
  nnoremap <silent> gaA :lua require('textcase').lsp_rename('to_phrase_case')<CR>
  nnoremap <silent> gaC :lua require('textcase').lsp_rename('to_camel_case')<CR>
  nnoremap <silent> gaP :lua require('textcase').lsp_rename('to_pascal_case')<CR>
  nnoremap <silent> gaT :lua require('textcase').lsp_rename('to_title_case')<CR>
  nnoremap <silent> gaF :lua require('textcase').lsp_rename('to_path_case')<CR>

  nnoremap <silent> gaou :lua require('textcase').operator('to_upper_case')<CR>
  nnoremap <silent> gaol :lua require('textcase').operator('to_lower_case')<CR>
  nnoremap <silent> gaos :lua require('textcase').operator('to_snake_case')<CR>
  nnoremap <silent> gaoh :lua require('textcase').operator('to_dash_case')<CR>
  nnoremap <silent> gaon :lua require('textcase').operator('to_constant_case')<CR>
  nnoremap <silent> gaod :lua require('textcase').operator('to_dot_case')<CR>
  nnoremap <silent> gaoa :lua require('textcase').operator('to_phrase_case')<CR>
  nnoremap <silent> gaoc :lua require('textcase').operator('to_camel_case')<CR>
  nnoremap <silent> gaop :lua require('textcase').operator('to_pascal_case')<CR>
  nnoremap <silent> gaot :lua require('textcase').operator('to_title_case')<CR>
  nnoremap <silent> gaof :lua require('textcase').operator('to_path_case')<CR>

  if s:enable_whichkey
    let g:which_key_gmap['a'] = {
          \ 'name' : '+text-case-current-word',
          \ 'u' : 'To upper case',
          \ 'l' : 'To lower case',
          \ 's' : 'To snake case',
          \ 'h' : 'To dash case',
          \ 'n' : 'To constant case',
          \ 'd' : 'To dot case',
          \ 'a' : 'To phrase case',
          \ 'c' : 'To camel case',
          \ 'p' : 'To pascal case',
          \ 't' : 'To title case',
          \ 'f' : 'To path case',
          \ 'U' : 'To upper case (lsp rename)',
          \ 'L' : 'To lower case (lsp rename)',
          \ 'S' : 'To snake case (lsp rename)',
          \ 'H' : 'To dash case (lsp rename)',
          \ 'N' : 'To constant case (lsp rename)',
          \ 'D' : 'To dot case (lsp rename)',
          \ 'A' : 'To phrase case (lsp rename)',
          \ 'C' : 'To camel case (lsp rename)',
          \ 'P' : 'To pascal case (lsp rename)',
          \ 'T' : 'To title case (lsp rename)',
          \ 'F' : 'To path case (lsp rename)',
          \ 'o' : {
                \ 'name' : '+operator',
                \ 'u' : 'To upper case',
                \ 'l' : 'To lower case',
                \ 's' : 'To snake case',
                \ 'h' : 'To dash case',
                \ 'n' : 'To constant case',
                \ 'd' : 'To dot case',
                \ 'a' : 'To phrase case',
                \ 'c' : 'To camel case',
                \ 'p' : 'To pascal case',
                \ 't' : 'To title case',
                \ 'f' : 'To path case',
                \ },
          \ }
  endif
endif

if dein#tap('rest.nvim')
  nnoremap chr <Plug>RestNvim
  nnoremap chp <Plug>RestNvim
  nnoremap chl <Plug>RestNvim

  if s:enable_whichkey
    let g:which_key_map['c']['h'] = {
          \ 'name' : '+http-client',
          \ 'r' : 'Run Rest http request under cursor',
          \ 'p' : 'Preview http requrest cURL command',
          \ 'l' : 'Re-run last http request',
          \ }
  endif
endif

if dein#tap('gina.vim')
  nnoremap <silent> <Leader>ga :Gina add %:p<CR>
  nnoremap <silent> <Leader>gA :Gina add .<CR>
  nnoremap <silent> <leader>gb :Gina blame --width=40<CR>
  nnoremap <silent> <Leader>gc :Gina commit<CR>
  nnoremap <silent> <leader>gd :Gina compare<CR>
  nnoremap <silent> <Leader>gF :Gina fetch<CR>
  nnoremap <silent> <Leader>gl :Gina log --graph --all<CR>
  nnoremap <silent> <leader>go :Gina browse<CR>
  vnoremap <silent> <leader>go :Gina browse<CR>
  nnoremap <silent> <Leader>gp :Gina! push<CR>
  nnoremap <silent> <Leader>gP :Gina pull<CR>
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

if dein#tap('neogit')
  nnoremap <silent> <Leader>gn <cmd>Neogit<CR>

  if s:enable_whichkey
    let g:which_key_map['g']['n'] = 'Neogit'
  endif
endif

if dein#tap('gitsigns.nvim')
  " DEPRECATED: Defined in nvim-treesitter-textobjects
  " nmap [h <cmd>Gitsigns prev_hunk<CR>
  " nmap ]h <cmd>Gitsigns next_hunk<CR>
  nnoremap <Leader>ghb <cmd>lua require"gitsigns".blame_line{full=true}<CR>
  nnoremap <Leader>ghd <cmd>Gitsigns diffthis<CR>
  nnoremap <Leader>ghD <cmd>lua require"gitsigns".diffthis("~")<CR>
  nnoremap <Leader>ghp <cmd>Gitsigns preview_hunk<CR>
  nnoremap <Leader>ghr <cmd>Gitsigns reset_hunk<CR>
  vnoremap <Leader>ghr <cmd>Gitsigns reset_hunk<CR>
  nnoremap <Leader>ghR <cmd>Gitsigns reset_buffer<CR>
  nnoremap <Leader>ghs <cmd>Gitsigns stage_hunk<CR>
  vnoremap <Leader>ghs <cmd>Gitsigns stage_hunk<CR>
  nnoremap <Leader>ghu <cmd>Gitsigns undo_stage_hunk<CR>

  if s:enable_whichkey
    let g:which_key_rsbmap['g'] = 'Git next hunk'
    let g:which_key_lsbmap['g'] = 'Git prev hunk'

    let g:which_key_map['g']['h'] = {
          \ 'name' : '+git-hunks',
          \ 'b' : 'Blame current line (full)',
          \ 'd' : 'Diffthis current line',
          \ 'D' : 'Diffthis buffer',
          \ 'p' : 'Preview hunk',
          \ 'r' : 'Reset current hunk',
          \ 'R' : 'Reset buffer',
          \ 's' : 'Stage current hunk',
          \ 'u' : 'Undo current hunk',
          \ }
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
  nnoremap <LocalLeader>sx :<C-u>ColorizerToggle<CR>
  if s:enable_whichkey
    let g:which_key_localmap['s']['x'] = 'Colorizer Toggle'
  endif
endif

if dein#tap('vim-abolish')
  nnoremap <Leader>rs :<C-u>Subvert//g<Left><Left>
  vnoremap <Leader>rs :Subvert//g<Left><Left>
  nnoremap <Leader>rS :<C-u>%Subvert//g<Left><Left>
  " Duplicate line and subvert. Uses "x register for yanking and pasting
  nnoremap <Leader>rp yap}pV`[v`]:Subvert//g<bar>norm`.$
     \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
  vnoremap <Leader>rp y`]p`[v`]:Subvert//g<Left><Left>

  if s:enable_whichkey
    let g:which_key_map['r']['s'] = 'Subvert line /{pat}/{sub}/[flags]'
    let g:which_key_map['r']['S'] = 'Subvert file /{pat}/{sub}/[flags]'
    let g:which_key_map['r']['p'] = 'Duplicate line(s) and Subvert'
  endif
endif

if dein#tap('vim-you-autocorrect')
  nnoremap <silent> <LocalLeader>ss <cmd>call ToggleAutoCorrect()<CR>
  " nmap <silent> [s <Plug>VimyouautocorrectPrevious
  " nmap <silent> ]s <Plug>VimyouautocorrectNext

  imap <silent> <F3> <C-O><Plug>VimyouautocorrectUndo
  nmap <silent> <F3> <Plug>VimyouautocorrectUndo
  imap <silent> <F4> <C-O><Plug>VimyouautocorrectPrevious
  imap <silent> <F5> <C-O><Plug>VimyouautocorrectNext

  if s:enable_whichkey
    let g:which_key_localmap['s']['s'] = 'Toggle autocorrect (certain ft only)'
    " let g:which_key_lsbmap['s'] = 'Previous autocorrect'
    " let g:which_key_rsbmap['s'] = 'Next autocorrect'
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
          \ 'l' : 'Execute last far command',
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
    echom 'Elite mode off'
    let g:elite_mode=v:false
  else
    if dein#tap('delimitMate') | exec 'silent! DelimitMateOff' | endif
    if dein#tap('coc.nvim')
      exec 'silent! CocDisable'
    endif
    echom 'Elite mode on'
    let g:elite_mode=v:true
  endif
endfunction

nnoremap <Leader>E :<C-u>EliteModeToggle<CR>

command! -nargs=0 EliteModeToggle call EliteModeToggle()
