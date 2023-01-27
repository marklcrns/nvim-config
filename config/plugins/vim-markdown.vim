let g:vim_markdown_math = 1
let g:vim_markdown_folding_disabled = 1
" let g:vim_markdown_folding_level = 1
" let g:vim_markdown_folding_style_pythonic = 1
let g:vim_markdown_auto_insert_bullets = 0
let g:vim_markdown_new_list_item_indent = 0
let g:vim_markdown_frontmatter = 1
let g:vim_markdown_auto_insert_bullets = 1
let g:vim_markdown_new_list_item_indent = 1
let g:vim_markdown_conceal_code_blocks = 0
let g:vim_markdown_conceal = 0
let g:vim_markdown_strikethrough = 1
let g:vim_markdown_edit_url_in = 'vsplit'
let g:vim_markdown_toc_autofit = 1
let g:vim_markdown_fenced_languages = [
  \ 'c++=cpp',
  \ 'viml=vim',
  \ 'bash=sh',
  \ 'ini=dosini',
  \ 'js=javascript',
  \ 'json=javascript',
  \ 'jsx=javascriptreact',
  \ 'tsx=typescriptreact',
  \ 'docker=Dockerfile',
  \ 'makefile=make',
  \ 'py=python'
  \ ]

augroup MarkdownEditMode
  autocmd!
  " Toggle conceallevel on and off Insert mode
  autocmd FileType markdown
        \ autocmd InsertEnter <buffer> setlocal conceallevel=0
  autocmd FileType markdown
        \ autocmd InsertLeave <buffer> setlocal conceallevel=2

  " Toggles conceallevel on and off Visual Mode
  autocmd FileType markdown
        \ autocmd ModeChanged [vV\x16]*:* let &l:cole = 2
  autocmd FileType markdown
        \ autocmd ModeChanged *:[vV\x16]* let &l:cole = 0
augroup END

