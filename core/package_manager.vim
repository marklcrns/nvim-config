" Set custom augroup
augroup user_events
	autocmd!
augroup END

let s:cache_path = $DATA_PATH . '/dein'

if has('vim_starting')
	" When using VIMINIT trick for exotic MYVIMRC locations, add path now.
	if &runtimepath !~# $VIM_PATH
		set runtimepath^=$VIM_PATH
	endif

	" Ensure data directories
	for s:path in [
				\ $DATA_PATH,
				\ $DATA_PATH . '/undo',
				\ $DATA_PATH . '/backup',
				\ $DATA_PATH . '/session',
				\ $VIM_PATH . '/spell' ]
		if ! isdirectory(s:path)
			call mkdir(s:path, 'p')
		endif
	endfor

	" Python interpreter settings
	if has('nvim')
		" Set python interpreter from a dedicated virtualenv created by generate_venv.sh
		let s:python = $DATA_PATH . '/venv/python/env/bin/python'
		let s:python3 = $DATA_PATH . '/venv/python3/env/bin/python3'
		if filereadable(s:python)
			let g:python_host_prog = s:python
		endif
		if filereadable(s:python3)
			let g:python3_host_prog = s:python3
		endif
	elseif has('pythonx')
		if has('python3')
			set pyxversion=3
		elseif has('python')
			set pyxversion=2
		endif
	endif

	" Use dein as a plugin manager
	let g:dein#auto_recache = v:true
	let g:dein#lazy_rplugins = v:true
	let g:dein#install_max_processes = 12
	let g:dein#install_progress_type = 'title'
	let g:dein#enable_notification = v:true
	let g:dein#install_log_filename = $DATA_PATH . '/dein.log'

	" Add dein to vim's runtimepath
	if &runtimepath !~# '/dein.vim'
		let s:dein_dir = s:cache_path . '/repos/github.com/Shougo/dein.vim'
		" Clone dein if first-time setup
		if ! isdirectory(s:dein_dir)
			execute '!git clone https://github.com/Shougo/dein.vim' s:dein_dir
			if v:shell_error
				call s:error('dein installation has failed! is git installed?')
				finish
			endif
		endif

		execute 'set runtimepath+='.substitute(
					\ fnamemodify(s:dein_dir, ':p') , '/$', '', '')
	endif
endif

let s:rc_dir = expand($HOME . '/.config/nvim')
let s:toml = s:rc_dir . '/config/dein.toml'
let s:lazy_toml = s:rc_dir . '/config/dein_lazy.toml'
if dein#load_state(s:cache_path)
	call dein#begin(s:cache_path, [
				\ expand('<sfile>'), s:toml, s:lazy_toml,
				\ ])

	call dein#load_toml(s:toml, {'lazy': 0})
	call dein#load_toml(s:lazy_toml, {'lazy': 1})

	call dein#end()

	" Save cached state for faster startups
	if ! g:dein#_is_sudo
		call dein#save_state()
	endif

	" Update or install plugins if a change detected
	if dein#check_install()
		if ! has('nvim')
			set nomore
		endif
		call dein#install()
	endif
endif

filetype plugin indent on

" Only enable syntax when vim is starting
if has('vim_starting')
	syntax enable
endif

" Trigger source event hooks
call dein#call_hook('source')
call dein#call_hook('post_source')

" Required:
filetype plugin indent on
syntax enable

