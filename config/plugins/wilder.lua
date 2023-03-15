vim.cmd([[
call wilder#setup({
     \'modes': [':', '/', '?'],
     \ 'next_key': '<Tab>',
     \ 'previous_key': '<S-Tab>',
     \ 'accept_key': '<Down>',
     \ 'reject_key': '<Up>',
     \ })

call wilder#set_option('pipeline', [
      \ wilder#debounce(10),
      \ wilder#branch(
      \   wilder#cmdline_pipeline({'language': has('nvim') ? 'python' : 'vim'}),
      \   wilder#python_search_pipeline(),
      \ ),
      \ ])

call wilder#set_option('renderer', wilder#popupmenu_renderer(wilder#popupmenu_palette_theme({
      \ 'border': 'rounded',
      \ 'max_height': '50%',
      \ 'min_height': 0,
      \ 'prompt_position': 'top',
      \ 'reverse': 0,
      \ })))
]])
