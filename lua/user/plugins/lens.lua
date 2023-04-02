return function()
  vim.cmd([[
    let g:lens#disabled_filetypes = [
          \ 'NeogitCommitMessage',
          \ 'NeogitStatus',
          \ 'Outline',
          \ 'dap-repl',
          \ 'dapui_breakpoints',
          \ 'dapui_console',
          \ 'dapui_scopes',
          \ 'dapui_stacks',
          \ 'dapui_watches',
          \ 'dashboard',
          \ 'gina-commit',
          \ 'gina-status',
          \ 'help',
          \ 'minimap',
          \ 'qf', 'toggleterm',
          \ 'lspsagaoutline',
          \ 'lspsagafinder',
          \ 'neo-tree',
          \ 'mind'
          \ ]

    let g:lens#disabled_buftypes = [
          \ 'terminal',
          \ 'nofile',
          \ 'help',
          \ 'quickfix',
          \ 'location',
          \ 'prompt',
          \ ]

    let g:lens#animate = 1
    " let g:lens#height_resize_min = 40
    " let g:lens#height_resize_max = 40
    " let g:lens#width_resize_min = 80
    " let g:lens#width_resize_max = 120
    "
  ]])
end
