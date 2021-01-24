let g:vimtex_compiler_latexmk = {
			\ 'build_dir' : 'build',
			\ 'callback' : 1,
			\ 'continuous' : 1,
			\ 'executable' : 'latexmk',
			\ 'hooks' : [],
			\ 'options' : [
			\   '-verbose',
			\   '-file-line-error',
			\   '-synctex=1',
			\   '-interaction=nonstopmode',
			\ ],
			\}

let g:vimtex_view_method = 'zathura'
let g:vimtex_mappings_enabled = 1

let g:vimtex_quickfix_ignore_filters = [
			\ 'LaTeX Font Warning',
			\ ]
