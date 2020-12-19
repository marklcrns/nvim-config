let g:codi#autocmd = "TextChanged"

let g:codi#interpreters = {
    \ 'python': {
        \ 'bin': 'python3',
        \ 'prompt': '^\(>>>\|\.\.\.\) ',
        \ 'rightalign': 1,
        \ },
    \ 'javascript': {
        \ 'bin': 'node',
        \ 'prompt': '^\(>\|\.\.\.\+\) ',
        \ 'rightalign': 1,
        \ },
    \ 'cpp': {
        \ 'bin': 'cling',
        \ 'prompt': '^\(>\|\.\.\.\+\) ',
        \ 'rightalign': 1,
        \ },
    \ 'java': {
        \ 'bin': 'jshell',
        \ 'prompt': '\(jshell> \)',
        \ 'rightalign': 1,
        \ },
\ }

