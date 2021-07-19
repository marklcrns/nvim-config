let g:rooter_change_directory_for_non_project_files = 'current'
let g:rooter_manual_only = 1
let g:rooter_patterns = [
    \ '=src',
    \ '.git/',
    \ 'README.*',
    \ 'node_modules/',
    \ 'pom.xml',
    \ 'env/',
    \ '.root',
    \ '.editorconfig',
    \ 'Makefile',
    \ 'makefile',
    \ ]
let g:rooter_silent_chdir = 1
let g:rooter_resolve_links = 1
let g:rooter_cd_cmd = 'lcd'

