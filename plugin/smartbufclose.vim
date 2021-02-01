" File: smartbufclose.vim
"
" Author:
"   Mark Lucernas
"   https://github.com/marklcrns
"
" Description:
"   Sensibly delete current buffer with respect to alternate tabs and window
"   splits, and other types of buffer.
"
" Features:
"   - Delete buffers with preserving tabs and window splits displaying the same
"     buffer to be deleted.
"   - Keep tabs and window splits open with an empty buffer if pointing to
"     same buffer to be deleted.
"   - Auto delete empty buffers (will close tabs and window splits).
"   - Prevents from deleting buffer if modified.
"   - Handles diff splits, closing all blob buffers and extra splits
"     automatically.
"   - Plugins Support: vim-fugitive, gina, goyo, vim-mundo, qf, fern, nvim-tree,
"		  minimap, vista.
"
" Usage:
"   :SmartBufClose
"   noremap q :SmartBufClose<CR>
"
" Credits:
"   - CleanEmptyBuffers()
"     https://stackoverflow.com/a/10102604
"   - SmartBufClose()
"     https://github.com/cespare/vim-sbd
"     https://stackoverflow.com/a/29236158
"     https://superuser.com/questions/345520/vim-number-of-total-buffers
"




" List of excluded filetypes to preserve windows when clearing splits
" see CloseAllModifiableWin()
let g:smartbufclose_excluded_filetypes = [
			\ 'vista', 'fern', 'NvimTree', 'Mundo', 'MundoDiff', 'minimap',
			\ 'fugitive', 'gitcommit' 
			\ ]

function! s:CleanEmptyBuffers()
	let buffers = filter(range(1, bufnr('$')), 'buflisted(v:val) && empty(bufname(v:val)) && bufwinnr(v:val)<0 && !getbufvar(v:val, "&mod")')
	if !empty(buffers)
		" Wipe all empty buffers
		execute 'bw ' . join(buffers, ' ')
	endif
endfunction

function! s:ShiftAllWindowsBufferPointingToBuffer(buffer)
	" Loop through tabs
	for i in range(1, tabpagenr('$'))
		" Go to tab
		execute 'tabnext ' . i

		if winnr('$') ># 1
			" Store active window nr to restore later
			let curWin = winnr()

			" Loop over windows pointing to curBuf
			let winnr = bufwinnr(a:buffer)
			while (winnr >= 0)
				" Go to window and switch to next buffer
				execute winnr . 'wincmd w | bnext'
				" Restore active window
				execute curWin . 'wincmd w'
				let winnr = bufwinnr(a:buffer)
			endwhile
		endif
	endfor
endfunction

" Close all splits excluding given filetype list
function! s:CloseAllModifiableWin(excluded_filetypes)
	let splitsClosed = 0
	" Close window splits if > 1
	if winnr('$') ># 1
		let excludedFiletypes = join(a:excluded_filetypes, '\|')
		" Store active window nr to restore later
		let curWin = winnr()
		" Loop over window splits
		for _ in range(1, winnr('$'))
			" Go to next window
			silent execute "wincmd w"
			" Close window splits if not in filetype exclusions, is modifiable, or empty
			if (&ft !~ excludedFiletypes || &modifiable) && &ft !=# ''
				execute "silent! close"
				let splitsClosed += 1
			endif
		endfor
		" Restore active window
		execute curWin . 'wincmd w'
		echo "splits closed " . splitsClosed
	endif

	" Return total window splits closed
	return splitsClosed
endfunction


function! s:DeleteBufPreservingSplit(bufNr)
	let curTabNr = tabpagenr()

	" Store listed buffers count
	let curBufCount = len(getbufinfo({'buflisted':1}))

	if curBufCount ># 1
		" Prevent tabs and windows from closing if pointing to the same curBuf
		" by switching to next buffer before deleting curBuf
		call s:ShiftAllWindowsBufferPointingToBuffer(a:bufNr)

		" Close buffer and restore active tab
		silent execute 'silent! bdelete' . a:bufNr
		silent execute 'silent! tabnext ' . curTabNr
		" Create blank buffer if ended up with unmodifiable buffer
		if !&modifiable
			execute 'enew'
		endif
	else
		" Create new buffer empty if no splits and delete curBuf
		execute 'enew'
		call s:ShiftAllWindowsBufferPointingToBuffer(a:bufNr)
		execute "silent! " . a:bufNr . "bdelete"
	endif
endfunction


" Exits diff mode no matter where you are
" Optional arg to close specific plugin blob buffer
function! s:HandleDiffBlobBuffer()
	" Loop over buffers
	for bufNr in range(1, bufnr('$'))
		if getwinvar(bufwinnr(bufNr), '&diff') == 1
			" Go to the diff buffer window and quit
			execute bufwinnr(bufNr) . 'wincmd w | q'
		endif
	endfor
endfunction


function! <SID>SmartBufClose()
	let curBufNr = bufnr('%')
	let curBufName = bufname('%')
	let curTabNr = tabpagenr()

	call s:CleanEmptyBuffers()
	" Store listed buffers count
	let curBufCount = len(getbufinfo({'buflisted':1}))

	" Immediately quit/wipe certain buffers or filetype
	if &buftype ==# 'terminal'
		silent execute 'bw!'
		return
	elseif &diff
		call s:HandleDiffBlobBuffer()
		return
	elseif exists("#goyo")
		" Hacky workaround to delete buffer while in Goyo mode without exiting or
		" to turn off Goyo mode when only one buffer exists
		if curBufCount ># 1
			silent execute 'bn | bd#'
		else
			silent execute 'q | bn'
			call s:CleanEmptyBuffers()
		endif
		return
	elseif &filetype =~ 'gitcommit\|gina-\|gina-\|gina-\|diff' ||
				\ (!&modifiable || &readonly || curBufName ==# '')
		silent execute 'q'
		return
	elseif &filetype =~ 'git\|qf'
		silent execute 'bd'
		return
	elseif ((curBufCount ==# 1 && curBufName ==# '') || &buftype ==# 'nofile') " Quit when only buffer and empty
		" Close all splits if exists, else quit vim
		if s:CloseAllModifiableWin(g:smartbufclose_excluded_filetypes) ==# 0
			silent execute 'qa!'
			return
		endif
	endif

	" Create empty buffer if only buffer w/o window splits, else close split
	if getbufvar(curBufNr, '&modified') == 1
		echohl WarningMsg | echo "Changes detected. Please save your file!" | echohl None
	else
		call s:DeleteBufPreservingSplit(curBufNr)
	endif
endfunction

command! -nargs=0 SmartBufClose call <SID>SmartBufClose()


" DEPRECATED: For code reference only
" -----
" " Return true if has fugitive buffer open
" function! s:HasFugitiveDiffBuf()
" 	for bufferNum in range(1, bufnr('$'))
" 		if bufname(bufferNum) =~ '^fugitive:'
" 			return v:true
" 		endif
" 	endfor
" 	return v:false
" endfunction
"
" " Return true if has plugin buffer open
" function! s:HasPluginDiffBuf(pluginName)
" 	for bufferNum in range(1, bufnr('$'))
" 		if bufname(bufferNum) =~ '^' . a:pluginName . ':'
" 			return v:true
" 		endif
" 	endfor
" 	return v:false
" endfunction
"
" " If in fugitive blob buffer, close fugitive blob buffer and everything
" " related to it, else just close all fugitive blob buffer
" function! s:HandleFugitiveDiffBuffers()
" 	if bufname('%') =~ '^fugitive:'
" 		let fugitiveBlobBufPath= expand('#' . bufnr('%') . ':p')
" 		" Delete all buffer with similar path to fugitive blob buffer
" 		for bufferNum in range(1, bufnr('$'))
" 			if bufname(bufferNum) =~ fugitiveBlobBufPath || bufname(bufferNum) =~ '^fugitive:'
" 				silent execute 'bd ' . bufferNum
" 			endif
" 		endfor
" 		" Delete fugitive blob buffer
" 		call s:DeleteBufPreservingSplit(bufnr('%'))
" 	else
" 		" Delete all fugitive blob buffers
" 		for bufferNum in range(1, bufnr('$'))
" 			if bufname(bufferNum) =~ '^fugitive:'
" 				silent execute 'bd ' . bufferNum
" 			endif
" 		endfor
" 	endif
" endfunction
