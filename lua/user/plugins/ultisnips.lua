return function()
  -- nvim-cmp integration
  -- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#ultisnips--cmp-cmdline
  vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
  vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
  vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
  vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
  -- vim.g.UltiSnipsRemoveSelectModeMappings = 0

  vim.cmd([[
    " Let coc.nvim coc-ultisnips plugin handle the expand trigger mapping
    " See coc configs
    let g:UltiSnipsNoPythonWarning = 1

    let g:UltiSnipsSnippetDirectories = [
          \ $DATA_PATH . '/dein/repos/github.com/honza/vim-snippets/UltiSnips',
          \ $DATA_PATH . '/dein/repos/github.com/mlaursen/vim-react-snippets/UltiSnips',
          \ $VIM_PATH . '/snippets/ultisnips/'
          \ ]

    " If you want :UltiSnipsEdit to split your window.
    let g:UltiSnipsEditSplit = 'vertical'

    " Manual mapping of Visual and Selection
    " snoremap <silent> <Tab> <Esc>:call UltiSnips#ExpandSnippet()<cr>
    " xnoremap <silent> <Tab> :call UltiSnips#SaveLastVisualSelection()<cr>gvs
  ]])
end
