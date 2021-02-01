" Plugin key settings
let s:enable_whichkey = dein#tap('vim-which-key')

if s:enable_whichkey
	function! InitWhickey()
		let s:leader_key=substitute(get(g:,"mapleader","\\"), ' ', '<Space>', '')
		let s:localleader_key= get(g:,'maplocalleader',';')
		execute 'nnoremap <silent> <Leader> :<c-u>WhichKey "'.s:leader_key.'"<CR>'
		execute 'vnoremap <silent> <Leader> :<c-u>WhichKeyVisual "'.s:leader_key.'"<CR>'
		execute 'nnoremap <silent> <LocalLeader> :<c-u>WhichKey "' .s:localleader_key.'"<CR>'
		execute 'vnoremap <silent> <LocalLeader> :<c-u>WhichKeyVisual "'.s:localleader_key.'"<CR>'
		execute 'nnoremap <silent> [ :<c-u>WhichKey "["<CR>'
		execute 'nnoremap <silent> ] :<c-u>WhichKey "]"<CR>'
	endfunction
	call InitWhickey()

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
endif

if dein#tap('any-jump.vim')
	nnoremap <silent> <leader>ab :AnyJumpBack<CR>
	nnoremap <silent> <Leader>aj :AnyJump<CR>
	xnoremap <silent> <Leader>aj :AnyJumpVisual<CR>
	nnoremap <silent> <leader>al :AnyJumpLastResults<CR>
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

	nnoremap <silent> <leader>cs :<C-u>CocSearch<Space>
	nnoremap <silent> <leader>cS :<C-u>CocSearch -w<Space>

	nmap <leader>cr <Plug>(coc-refactor)

	" Movement within 'ins-completion-menu'
	imap <expr><C-j> pumvisible() ? "\<Down>" : "\<C-j>"
	imap <expr><C-k> pumvisible() ? "\<Up>" : "<C-k>"

	" Scroll pages in menu
	" inoremap <expr><C-f> pumvisible() ? "\<PageDown>" : "\<Right>" a
	" inoremap <expr><C-b> pumvisible() ? "\<PageUp>" : "\<Left>"
	" imap     <expr><C-d> pumvisible() ? "\<PageDown>" : "\<C-d>"
	" imap     <expr><C-u> pumvisible() ? "\<PageUp>" : "\<C-u>"

	nnoremap <expr><C-n> coc#util#has_float() ?
				\ coc#util#float_scrollable() ?
				\ coc#util#float_scroll(1)
				\ : ""
				\ : "\<C-n>"
	nnoremap <expr><C-p> coc#util#has_float() ?
				\ coc#util#float_scrollable() ?
				\ coc#util#float_scroll(0)
				\ : ""
				\ : "\<C-p>"

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
		inoremap <silent> <buffer> <Tab>   <C-R>=clap#navigation#linewise('down')<CR>
		inoremap <silent> <buffer> <S-Tab> <C-R>=clap#navigation#linewise('up')<CR>
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
endif

if dein#tap('codi.vim')
	nnoremap <Leader>icc :<C-u>Codi!!<CR>
	nnoremap <Leader>icu :<C-u>CodiUpdate<CR>
endif

if dein#tap('vim-easy-align')
	" Start interactive EasyAlign in visual mode
	xmap <Leader>raa <Plug>(EasyAlign)
	" Start interactive EasyAlign for a motion/text object
	nmap <Leader>raa <Plug>(EasyAlign)
	" Start Live-interactive EasyAlign in visual mode
	xmap <Leader>rAA <Plug>(LiveEasyAlign)
	" Start Live-interactive EasyAlign for a motion/text object
	nmap <Leader>rAA <Plug>(LiveEasyAlign)
endif

if dein#tap('vim-mundo')
	nnoremap <silent> <Leader>ou :MundoToggle<CR>
	let g:which_key_map['o']['u'] = 'Undo tree toggle'
endif

if dein#tap('vim-choosewin')
	nmap <Leader>- <Plug>(choosewin)
	nmap <Leader>_ :<C-u>ChooseWinSwapStay<CR>
endif

if dein#tap('caw.vim')
	function! InitCaw() abort
		if ! (&l:modifiable && &buftype ==# '')
			silent! nunmap <buffer> <Leader>V
			silent! xunmap <buffer> <Leader>V
			silent! nunmap <buffer> <Leader>v
			silent! xunmap <buffer> <Leader>v
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
			nmap <buffer> gcc <Plug>(caw:hatpos:toggle)
			xmap <buffer> gcc <Plug>(caw:hatpos:toggle)
		endif
	endfunction
	autocmd FileType * call InitCaw()
	call InitCaw()
endif

" if dein#tap('vim-smoothie')
"   nnoremap <silent> <C-f> :<C-U>call smoothie#forwards()<CR>
"   nnoremap <silent> <C-b> :<C-U>call smoothie#backwards()<CR>
"   nnoremap <silent> <C-d> :<C-U>call smoothie#downwards()<CR>
"   nnoremap <silent> <C-u> :<C-U>call smoothie#upwards()<CR>
" endif

if dein#tap('accelerated-jk')
	" Position-driven acceleration
	nmap j <Plug>(accelerated_jk_gj_position)
	nmap k <Plug>(accelerated_jk_gk_position)

	" " Time-driven acceleration (has problems with repeating macro)
	" nmap j <Plug>(accelerated_jk_gj)
	" nmap k <Plug>(accelerated_jk_gk)
endif

if dein#tap('python_match.vim')
	autocmd FileType python
				\ nmap <buffer> {{ [%
				\ | nmap <buffer> }} ]%
endif

if dein#tap('goyo.vim')
	nnoremap <Leader>ig :Goyo<CR>
endif

if dein#tap('fern.vim')
	" nnoremap <silent> <Leader>ee :<C-u>Fern . -drawer -keep -toggle -width=35 -reveal=%<CR><C-w>=
	nnoremap <silent> <Leader>ea :<C-u>Fern . -drawer -keep -toggle -width=35<CR>
endif

if dein#tap('nvim-tree.lua')
	nnoremap <silent> <Leader>ee :NvimTreeToggle<CR>
	nnoremap <silent> <Leader>ef :NvimTreeFindFile<CR>
	nnoremap <silent> <Leader>er :NvimTreeRefresh<CR>
endif

if dein#tap('dashboard-nvim')
	nnoremap <silent> <leader>sd :<C-u>Dashboard<CR>
endif

if dein#tap('vim-quickrun')
	nnoremap <silent> <Localleader>r :QuickRun -mode n<CR>
	vnoremap <silent> <LocalLeader>r :QuickRun -mode v<CR>
endif

if dein#tap('vim-floaterm')
	nnoremap <silent> <Leader>ota :Clap floaterm<CR>
	tnoremap <silent> <Leader>ota <C-\><C-n>:Clap floaterm<CR>
	nnoremap <silent> <Leader>otb :FloatermUpdate --wintype=normal --position=bottom<CR>
	tnoremap <silent> <Leader>otb <C-\><C-n>:FloatermUpdate --wintype=normal --position=bottom<CR>
	nnoremap <silent> <Leader>oth :FloatermHide<CR>
	tnoremap <silent> <Leader>oth <C-\><C-n>:FloatermHide<CR>
	nnoremap <silent> <Leader>otn :FloatermNext<CR>
	tnoremap <silent> <Leader>otn <C-\><C-n>:FloatermNext<CR>
	nnoremap <silent> <Leader>oto :FloatermNew<CR>
	tnoremap <silent> <Leader>oto <C-\><C-n>:FloatermNew<CR>
	nnoremap <silent> <Leader>otp :FloatermPrev<CR>
	tnoremap <silent> <Leader>otp <C-\><C-n>:FloatermPrev<CR>
	nnoremap <silent> <Leader>otq :FloatermKill<CR>
	tnoremap <silent> <Leader>otq <C-\><C-n>:FloatermKill<CR>
	nnoremap <silent> <Leader>otQ :FloatermKill!<CR>
	tnoremap <silent> <Leader>otQ <C-\><C-n>:FloatermKill!<CR>
	nnoremap <silent> <Leader>otr :FloatermNew ranger<CR>
	tnoremap <silent> <Leader>otr <C-\><C-n>:FloatermNew ranger<CR>
	nnoremap <silent> <Leader>ots :FloatermShow<CR>
	tnoremap <silent> <Leader>ots <C-\><C-n>:FloatermShow<CR>
	nnoremap <silent> <Leader>otS :FloatermSend<CR>
	nnoremap <silent> <Leader>ott :FloatermToggle<CR>
	tnoremap <silent> <Leader>ott <C-\><C-n>:FloatermToggle<CR>
	nnoremap <silent> <Leader>otu :FloatermUpdate<CR>
	tnoremap <silent> <Leader>otu <C-\><C-n>:FloatermUpdate<CR>
	tnoremap <silent> <Leader>otv <C-\><C-n>:FloatermUpdate --wintype=normal --position=right<CR>
	nnoremap <silent> <Leader>otv :FloatermUpdate --wintype=normal --position=right<CR>
endif

if dein#tap('vim-expand-region')
	xmap v <Plug>(expand_region_expand)
	xmap V <Plug>(expand_region_shrink)
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

if dein#tap('minimap.vim')
	nnoremap <silent><Leader>omm :MinimapToggle<CR>
	nnoremap <silent><Leader>omq :MinimapClose<CR>
	nnoremap <silent><Leader>omr :MinimapRefresh<CR>

	if s:enable_whichkey
		let g:which_key_map['o']['m'] = {
					\ 'name' : '+Minimap',
					\ 'm' : 'Minimap Toggle',
					\ 'q' : 'Minimap Close',
					\ 'r' : 'Minimap Refresh',
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


" if dein#tap('vim-operator-replace')
"   xmap p <Plug>(operator-replace)
" endif

if dein#tap('linediff.vim')
	nmap <silent> <leader>idla :<C-u>LinediffAdd<CR>
	vmap <silent> <leader>idla :LinediffAdd<CR>
	nmap <silent> <leader>idlA :<C-u>LinediffAdd<C-a>
	nmap <silent> <leader>idld :<C-u>Linediff<CR>
	vmap <silent> <leader>idld :Linediff<CR>
	nmap <silent> <leader>idll :<C-u>LinediffLast<CR>
	vmap <silent> <leader>idll :LinediffLast<CR>
	nmap <silent> <leader>idlm :<C-u>LinediffMerge<CR>
	nmap <silent> <leader>idlp :<C-u>LinediffPick<CR>
	nmap <silent> <leader>idlr :<C-u>LinediffReset<CR>
	nmap <silent> <leader>idls :<C-u>LinediffShow<CR>
	" resets linediff with q when active
	autocmd User LinediffBufferReady nnoremap <buffer> q :LinediffReset<cr>
endif

if dein#tap('vim-zoom')
	nmap [Window]f <Plug>(zoom-toggle)
endif

if dein#tap('vim-rooter')
	nnoremap <Leader>frr :Rooter<CR>
endif

if dein#tap('rainbow')
	nmap <LocalLeader>sp :RainbowToggle<CR>
endif

if dein#tap('vim-diminactive')
	nnoremap <LocalLeader>sd :DimInactiveToggle<CR>
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

	nmap <Leader>lmd <Plug>MarkdownPreviewToggle
	nmap <Leader>lmo <Plug>MarkdownPreview
	nmap <Leader>lmc <Plug>MarkdownPreviewStop
endif

if dein#tap('vim-markdown')
	nnoremap <Leader>lmtt :<C-u>Toc<CR>
	nnoremap <Leader>lmtv :<C-u>Tocv<CR>
	nnoremap <Leader>lmth :<C-u>Toch<CR>
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
		setlocal laststatus=0 showtabline=0 colorcolumn=0
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

	if s:enable_whichkey
		let g:which_key_localmap.t = {
					\ 'name' : '+taskwiki',
					\ 'u' : ['call TaskWikiUpdate()', 'Custom taskwiki tasks update'],
					\ 'b' : {
					\ 'name' : '+taskwiki-burndown',
					\ },
					\ 'c' : {
					\ 'name' : '+taskwiki-choose',
					\ },
					\ 'h' : {
					\ 'name' : '+taskwiki-history',
					\ },
					\ 'G' : {
					\ 'name' : '+taskwiki-ghistory',
					\ },
					\ }
	endif
endif

if dein#tap('taskwarrior.vim')
	nnoremap <LocalLeader>tw :<C-u>TW<CR>

	if s:enable_whichkey
		let g:which_key_localmap['t']['w'] = 'Open Task Warrior'
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
		let g:which_key_localmap['v'] = {
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

if dein#tap('vim-indent-guides')
	nmap <silent> <LocalLeader>si <Plug>IndentGuidesToggle
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

if dein#tap('vim-wordy')
	" auto wildcharm trigger
	if !&wildcharm | set wildcharm=<C-z> | endif
	execute 'nnoremap <leader>lgww :Wordy<space>'.nr2char(&wildcharm)

	nnoremap <leader>lgwn :NextWordy<CR>
	nnoremap <leader>lgwp :PrevWordy<CR>
	nnoremap <leader>lgwr :NoWordy<CR>
endif

if dein#tap('vim-quickhl')
	nmap <Leader>iht <Plug>(quickhl-manual-this)
	xmap <Leader>iht <Plug>(quickhl-manual-this)

	nmap <Leader>ihw <Plug>(quickhl-manual-this-whole-word)
	xmap <Leader>ihw <Plug>(quickhl-manual-this-whole-word)

	nmap <Leader>ihr <Plug>(quickhl-manual-reset)
	xmap <Leader>ihr <Plug>(quickhl-manual-reset)
endif

if dein#tap('thesaurus_query.vim')
	nnoremap <silent> <Leader>rt :<C-u>ThesaurusQueryReplaceCurrentWord<CR>
	vnoremap <silent> <Leader>rt y:ThesaurusQueryReplace <C-r>"<CR>
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
	nnoremap <silent> <leader>gs :Gina status -s<CR>

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
	nmap <Leader>gr <Plug>(GitGutterUndoHunk)
	nmap gs <Plug>(GitGutterPreviewHunk)

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
endif

if dein#tap('nvim-colorizer.lua')
	nnoremap <LocalLeader>sc :<C-u>ColorizerToggle<CR>
endif

if dein#tap('vCoolor.vim')
	nnoremap <silent> <Leader>ltcpa :<C-u>VCoolIns ra<CR>
	nnoremap <silent> <Leader>ltcph :<C-u>VCoolIns h<CR>
	nnoremap <silent> <Leader>ltcpr :<C-u>VCoolIns r<CR>
	nnoremap <silent> <Leader>ltcpx :<C-u>VCoolor<CR>
endif

if dein#tap('vim-convert-color-to')
	" Normal mode
	nnoremap <Leader>ltca :<C-u>ConvertColorTo rgba<CR>
	nnoremap <Leader>ltch :<C-u>ConvertColorTo hsl<CR>
	nnoremap <Leader>ltcH :<C-u>ConvertColorTo hsla<CR>
	nnoremap <Leader>ltcr :<C-u>ConvertColorTo rgb_int<CR>
	nnoremap <Leader>ltcR :<C-u>ConvertColorTo rgb_float<CR>
	nnoremap <Leader>ltcx :<C-u>ConvertColorTo hex<CR>
	nnoremap <Leader>ltcX :<C-u>ConvertColorTo hexa<CR>
	" Visual mode
	vnoremap <Leader>ltca :ConvertColorTo rgba<CR>
	vnoremap <Leader>ltch :ConvertColorTo hsl<CR>
	vnoremap <Leader>ltcH :ConvertColorTo hsla<CR>
	vnoremap <Leader>ltcr :ConvertColorTo rgb_int<CR>
	vnoremap <Leader>ltcR :ConvertColorTo rgb_float<CR>
	vnoremap <Leader>ltcx :ConvertColorTo hex<CR>
	vnoremap <Leader>ltcX :ConvertColorTo hexa<CR>
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
endi

