" Plugin Manager

" Set custom augroup
augroup user_events
	autocmd!
augroup END

let $VIM_PATH =
			\ get(g:, 'etc_vim_path',
			\		exists('*stdpath') ? stdpath('config') :
			\		! empty($MYVIMRC) ? fnamemodify(expand($MYVIMRC), ':h') :
			\		! empty($VIMCONFIG) ? expand($VIMCONFIG) :
			\		! empty($VIM_PATH) ? expand($VIM_PATH) :
			\		fnamemodify(resolve(expand('<sfile>:p')), ':h:h')
			\ )

let s:plugins_yaml = ''
let s:plugins_toml = ''
let s:plugins_toml_lazy = ''
if get(g:, 'handle_plugins', 'full') !=# 'disable'
	if g:handle_plugins ==# 'full'
		if filereadable($VIM_PATH . '/config/plugins.yaml')
			let s:plugins_yaml = $VIM_PATH . '/config/plugins.yaml'
		endif
		if filereadable($VIM_PATH . '/config/plugins.toml')
			let s:plugins_toml = $VIM_PATH . '/config/plugins.toml'
		endif
		if filereadable($VIM_PATH . '/config/plugins_lazy.toml')
			let s:plugins_toml_lazy = $VIM_PATH . '/config/plugins_lazy.toml'
		endif
	elseif g:handle_plugins ==# 'minimal'
		if filereadable($VIM_PATH . '/config/plugins_minimal.yaml')
			let s:plugins_yaml = $VIM_PATH . '/config/plugins_minimal.yaml'
		endif
		if filereadable($VIM_PATH . '/config/plugins_minimal.toml')
			let s:plugins_toml = $VIM_PATH . '/config/plugins_minimal.toml'
		endif
		if filereadable($VIM_PATH . '/config/plugins_minimal_lazy.toml')
			let s:plugins_toml_lazy = $VIM_PATH . '/config/plugins_minimal_lazy.toml'
		endif
	endif
endif

let s:local_plugins_yaml = ''
let s:local_plugins_toml = ''
let s:local_plugins_toml_lazy = ''
if get(g:, 'init_secondary_config', 1)
	if filereadable($LOCAL_VIM_PATH . '/config/plugins.yaml')
		let s:local_plugins_yaml = $LOCAL_VIM_PATH . '/config/plugins.yaml'
	endif
	if filereadable($LOCAL_VIM_PATH . '/config/plugins.toml')
		let s:local_plugins_toml = $LOCAL_VIM_PATH . '/config/plugins.toml'
	endif
	if filereadable($LOCAL_VIM_PATH . '/config/plugins_lazy.toml')
		let s:local_plugins_toml_lazy = $LOCAL_VIM_PATH . '/config/plugins_lazy.toml'
	endif
endif

" Collection of user plugin list config file-paths
let s:config_paths = get(g:, 'etc_config_paths', [
			\ $VIM_PATH . '/usr/vimrc.yaml',
			\ $VIM_PATH . '/usr/vimrc.json',
			\ $VIM_PATH . '/vimrc.yaml',
			\ $VIM_PATH . '/vimrc.json',
			\ s:plugins_yaml,
			\ s:local_plugins_yaml,
			\ ])

" Collection of user plugin list config file-paths
let s:config_paths_toml = get(g:, 'etc_config_paths_toml', [
			\ s:plugins_toml,
			\ s:plugins_toml_lazy,
			\ s:local_plugins_toml,
			\ s:local_plugins_toml_lazy,
			\ ])


" Filter non-existent config paths
call filter(s:config_paths, 'filereadable(v:val)')

function! s:main()
	call s:use_{get(g:, 'package_manager', 'dein_yaml')}()
endfunction

function! s:use_dein_yaml()
	let l:cache_path = $DATA_PATH . '/dein'

	if has('vim_starting')
		" Use dein as a plugin manager
		let g:dein#auto_recache = v:true
		let g:dein#install_max_processes = 12
		let g:dein#install_progress_type = 'title'
		let g:dein#enable_notification = v:true
		let g:dein#install_log_filename = $DATA_PATH . '/dein.log'

		" Add dein to vim's runtimepath
		if &runtimepath !~# '/dein.vim'
			let s:dein_dir = l:cache_path . '/repos/github.com/Shougo/dein.vim'
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

	" Initialize dein.vim (package manager)
	if dein#load_state(l:cache_path)
		let l:rc = s:parse_config_files()
		if empty(l:rc)
			call s:error('Empty plugin list')
			return
		endif

		" Start propagating file paths and plugin presets
		call dein#begin(l:cache_path, extend([expand('<sfile>')], s:config_paths))
		for plugin in l:rc
			call dein#add(plugin['repo'], extend(plugin, {}, 'keep'))
		endfor

		" Add any local ./dev plugins
		if isdirectory($VIM_PATH . '/dev')
			call dein#local($VIM_PATH . '/dev', { 'frozen': 1, 'merged': 0 })
		endif
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
endfunction

function! s:use_dein_toml()
	let l:cache_path = $DATA_PATH . '/dein'

	if has('vim_starting')
		" Use dein as a plugin manager
		let g:dein#auto_recache = v:true
		let g:dein#lazy_rplugins = v:true
		let g:dein#install_max_processes = 12
		let g:dein#install_progress_type = 'title'
		let g:dein#enable_notification = v:true
		let g:dein#install_log_filename = $DATA_PATH . '/dein.log'

		" Add dein to vim's runtimepath
		if &runtimepath !~# '/dein.vim'
			let s:dein_dir = l:cache_path . '/repos/github.com/Shougo/dein.vim'
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

	" Initialize dein.vim (package manager)
	if dein#load_state(l:cache_path)
		" Start propagating file paths and plugin presets
		call dein#begin(l:cache_path, extend([expand('<sfile>')], s:config_paths_toml))

		for toml in s:config_paths_toml
			if empty(toml)
				continue
			endif
			" If 'lazy' is present in toml filename, set lazy
			call dein#load_toml(toml, {'lazy': stridx(toml, "lazy") !=# -1 ? 1 : 0})
		endfor

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
endfunction

function! s:parse_config_files()
	let l:merged = []
	try
		" Merge all lists of plugins together
		for l:cfg_file in s:config_paths
			let l:merged = extend(l:merged, s:load_config(l:cfg_file))
		endfor
	catch /.*/
		call s:error(
					\ 'Unable to read configuration files at ' . string(s:config_paths))
		echoerr v:exception
		echomsg 'Error parsing user configuration file(s).'
		echoerr 'Please run: pip3 install --user PyYAML'
		echomsg 'Caught: ' v:exception
	endtry

	" If there's more than one config file source,
	" de-duplicate plugins by repo key.
	if len(s:config_paths) > 1
		call s:dedupe_plugins(l:merged)
	endif
	return l:merged
endfunction

function! s:dedupe_plugins(list)
	let l:list = reverse(a:list)
	let l:i = 0
	let l:seen = {}
	while i < len(l:list)
		let l:key = list[i]['repo']
		if l:key !=# '' && has_key(l:seen, l:key)
			call remove(l:list, i)
		else
			if l:key !=# ''
				let l:seen[l:key] = 1
			endif
			let l:i += 1
		endif
	endwhile
	return reverse(l:list)
endfunction

" General utilities, mainly for dealing with user configuration parsing
" ---

function! s:error(msg)
	for l:mes in s:str2list(a:msg)
		echohl WarningMsg | echomsg '[config/init] ' . l:mes | echohl None
	endfor
endfunction

function! s:debug(msg)
	for l:mes in s:str2list(a:msg)
		echohl WarningMsg | echomsg '[config/init] ' . l:mes | echohl None
	endfor
endfunction

function! s:load_config(filename)
	" Parse YAML/JSON config file
	if a:filename =~# '\.json$'
		" Parse JSON with built-in json_decode
		let l:json = readfile(a:filename)
		return has('nvim') ? json_decode(l:json) : json_decode(join(l:json))
	elseif a:filename =~# '\.ya\?ml$'
		" Parse YAML with common command-line utilities
		return s:load_yaml(a:filename)
	endif
	call s:error('Unknown config file format ' . a:filename)
	return ''
endfunction

function! s:str2list(expr)
	" Convert string to list
	return type(a:expr) ==# v:t_list ? a:expr : split(a:expr, '\n')
endfunction

" YAML related
" ---

let g:yaml2json_method = ''

function! s:load_yaml(filename)
	if empty(g:yaml2json_method)
		let g:yaml2json_method = s:find_yaml2json_method()
	endif

	if g:yaml2json_method ==# 'ruby'
		let l:cmd = "ruby -e 'require \"json\"; require \"yaml\"; ".
					\ "print JSON.generate YAML.load \$stdin.read'"
	elseif g:yaml2json_method ==# 'python'
		let l:cmd = "python -c 'import sys,yaml,json; y=yaml.safe_load(sys.stdin.read()); print(json.dumps(y))'"
	elseif g:yaml2json_method ==# 'yq'
		let l:cmd = 'yq r -j -'
	else
		let l:cmd = g:yaml2json_method
	endif

	try
		let l:raw = readfile(a:filename)
		return json_decode(system(l:cmd, l:raw))
	catch /.*/
		call s:error([
					\ string(v:exception),
					\ 'Error loading ' . a:filename,
					\ 'Caught: ' . string(v:exception),
					\ 'Please run: pip install --user PyYAML',
					\ ])
	endtry
endfunction

function! s:find_yaml2json_method()
	if exists('*json_decode')
		" First, try to decode YAML using a CLI tool named yaml2json, there's many
		if executable('yaml2json') && s:test_yaml2json()
			return 'yaml2json'
		elseif executable('yq')
			return 'yq'
			" Or, try ruby. Which is installed on every macOS by default
			" and has yaml built-in.
		elseif executable('ruby') && s:test_ruby_yaml()
			return 'ruby'
			" Or, fallback to use python3 and PyYAML
		elseif executable('python') && s:test_python_yaml()
			return 'python'
		endif
		call s:error('Unable to find a proper YAML parsing utility')
	endif
	call s:error('Please upgrade to neovim +v0.1.4 or vim: +v7.4.1304')
endfunction

function! s:test_yaml2json()
	" Test yaml2json capabilities
	try
		let result = system('yaml2json', "---\ntest: 1")
		if v:shell_error != 0
			return 0
		endif
		let result = json_decode(result)
		return result.test
	catch
	endtry
	return 0
endfunction

function! s:test_ruby_yaml()
	" Test Ruby YAML capabilities
	call system("ruby -e 'require \"json\"; require \"yaml\"'")
	return (v:shell_error == 0) ? 1 : 0
endfunction

function! s:test_python_yaml()
	" Test Python YAML capabilities
	call system("python -c 'import sys,yaml,json'")
	return (v:shell_error == 0) ? 1 : 0
endfunction

call s:main()

" vim: set ts=2 sw=2 tw=80 noet :
