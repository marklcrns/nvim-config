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

if dein#tap('nvim-lspconfig')
  nnoremap <silent> [d :lua vim.diagnostic.goto_prev()<CR>
  nnoremap <silent> ]d :lua vim.diagnostic.goto_next()<CR>
  nnoremap <silent> gD :lua vim.lsp.buf.declaration()<CR>
  nnoremap <silent> gd :lua vim.lsp.buf.definition()<CR>
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

    let g:which_key_gmap['D'] = 'LSP go to definition'
    let g:which_key_gmap['i'] = 'LSP go to implementation'
    let g:which_key_gmap['r'] = 'LSP go to references'
    let g:which_key_gmap['t'] = 'LSP go to type definition'
  endif
endif

if dein#tap('null-ls.nvim')
  nnoremap <silent> <leader>cf :lua vim.lsp.buf.format({ async = true })<CR>
  nnoremap <silent> <Leader>cln <cmd>NullLsInfo<CR>

  if s:enable_whichkey
    let g:which_key_map['c']['f'] = 'Code format'
    let g:which_key_map['c']['l']['n'] = 'Lsp info (null-ls)'
  endif
endif

if dein#tap('lspsaga.nvim')
  nnoremap <silent> K :Lspsaga hover_doc<CR>
  " nnoremap <silent> gd :Lspsaga preview_definition<CR>
  nnoremap <silent> gf :Lspsaga lsp_finder<CR>
  nnoremap <silent> <leader>ca :Lspsaga code_action<CR>
  vnoremap <silent> <leader>ca :Lspsaga range_code_action<CR>
  nnoremap <silent> <leader>co :LSoutlineToggle<CR>
  nnoremap <silent> <leader>cr :Lspsaga rename<CR>
  nnoremap <silent> [e :Lspsaga diagnostic_jump_prev<CR>
  nnoremap <silent> ]e :Lspsaga diagnostic_jump_next<CR>

  if s:enable_whichkey
    let g:which_key_map['c']['a'] = 'Code action'
    let g:which_key_map['c']['o'] = 'Show code outline'
    let g:which_key_map['c']['r'] = 'LSP rename'

    let g:which_key_gmap['d'] = 'LSP go preview definition'
    let g:which_key_gmap['f'] = 'LSP finder'

    let g:which_key_lsbgmap['e'] = 'LSP Diagnostic prev'
    let g:which_key_rsbgmap['e'] = 'LSP Diagnostic next'
  endif
endif

if dein#tap('mason.nvim')
  nnoremap <silent> <leader>clm <cmd>Mason<CR>

  if s:enable_whichkey
    let g:which_key_map['c']['l']['m'] = 'Mason'
  endif
endif

if dein#tap('wilder.nvim')
  noremap <LocalLeader>so :call wilder#toggle()<CR>
  if s:enable_whichkey
    let g:which_key_localmap['s']['o'] = 'Toggle Wilder Completion'
  endif
endif

if dein#tap('vim-smartq')
  nmap <silent> <leader>fq <Plug>(smartq_this_save)
  if s:enable_whichkey
    let g:which_key_map['f']['q'] = 'SmartQ Save'
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

if dein#tap('tagbar')
  nnoremap <silent><Leader>itt :Tagbar<CR>

  if s:enable_whichkey
    let g:which_key_map['i']['t'] = {
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
  nnoremap <Leader><c-h> :SidewaysLeft<cr>
  nnoremap <Leader><c-l> :SidewaysRight<cr>
  if s:enable_whichkey
    let g:which_key_map['<C-H>'] = 'Sideways Left'
    let g:which_key_map['<C-L>'] = 'Sideways Right'
  endif
endif

if dein#tap('vim-zoom')
  nmap <silent> [Window]f <Plug>(zoom-toggle)
endif

if dein#tap('vim-rooter')
  nnoremap <Leader>frr :Rooter<CR>

  if s:enable_whichkey
    let g:which_key_map['f']['r']['r'] = 'Change to current buffer directory'
  endif
endif

if dein#tap('focus.nvim')
  nnoremap <LocalLeader>sr :<C-u>FocusToggle<CR>
  nnoremap <silent> [Window]z :<C-u>FocusMaxOrEqual<CR>

  if s:enable_whichkey
    let g:which_key_localmap['s']['r'] = 'Toggle Auto-resize'
  endif
endif

if dein#tap('winshift.nvim')
  nnoremap <C-W><Left>  :WinShift left<CR>
  nnoremap <C-W><Down>  :WinShift down<CR>
  nnoremap <C-W><Up>    :WinShift up<CR>
  nnoremap <C-W><Right> :WinShift right<CR>
  nnoremap <C-W>m       :WinShift swap<CR>
  nnoremap <C-W><C-M>   :WinShift<CR>
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
  nmap <LocalLeader>nw :<C-u>Neorg workspace<CR>
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

if dein#tap('vim-titlecase')
  nnoremap gZ  <Plug>Titlecase
  vnoremap gZ  <Plug>Titlecase
  nnoremap gZZ <Plug>TitlecaseLine
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
  nmap [g <cmd>Gitsigns prev_hunk<CR>
  nmap ]g <cmd>Gitsigns next_hunk<CR>
  nnoremap <Leader>ghb <cmd>lua require"gitsigns".blame_line{full=true}<CR>
  nnoremap <Leader>ghd <cmd>Gitsigns diffthis<CR>
  nnoremap <Leader>ghD <cmd>lua require"gitsigns".diffthis("~")<CR>
  nnoremap <Leader>ghp <cmd>Gitsigns preview_hunk<CR>
  nnoremap <Leader>ghr <cmd>Gitsigns reset_hunk<CR>
  vnoremap <Leader>ghr <cmd>Gitsigns reset_hunk<CR>
  vnoremap <Leader>ghR <cmd>Gitsigns reset_buffer<CR>
  nnoremap <Leader>ghs <cmd>Gitsigns stage_hunk<CR>
  vnoremap <Leader>ghs <cmd>Gitsigns stage_hunk<CR>
  nnoremap <Leader>ghu <cmd>Gitsigns undo_stage_hunk<CR>

  if s:enable_whichkey
    let g:which_key_rsbgmap['g'] = 'Git next hunk'
    let g:which_key_lsbgmap['g'] = 'Git prev hunk'

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
  nnoremap <Leader>rp yap}pV`[v`]:Subvert//g<bar>norm`.$
     \<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>
  vnoremap <Leader>rp y`]p`[v`]:Subvert//g<Left><Left>

  if s:enable_whichkey
    let g:which_key_map['r']['s'] = 'Subvert line /{pat}/{sub}/[flags]'
    let g:which_key_map['r']['S'] = 'Subvert file /{pat}/{sub}/[flags]'
    let g:which_key_map['r']['p'] = 'Duplicate line(s) and Subvert'
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
