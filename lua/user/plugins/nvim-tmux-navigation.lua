return function()
  require("nvim-tmux-navigation").setup({
    disable_when_zoomed = true, -- defaults to false
  })
  vim.cmd([[
    nnoremap <silent> <M-h> :NvimTmuxNavigateLeft<CR>
    nnoremap <silent> <M-j> :NvimTmuxNavigateDown<CR>
    nnoremap <silent> <M-k> :NvimTmuxNavigateUp<CR>
    nnoremap <silent> <M-l> :NvimTmuxNavigateRight<CR>
    nnoremap <silent> <M-\> :NvimTmuxNavigateLastActive<CR>
  ]])
end
