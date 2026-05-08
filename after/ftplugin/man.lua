vim.opt_local.wrap = false

-- Send all flag options to loclist
vim.keymap.set("n", "<M-o>", [[<Cmd>lvimgrep /\v^\s*--?\w+/j % <bar> lopen<CR>]], { buffer = true })

-- Navigate headings
vim.keymap.set("n", "]]", [[<Cmd>call search('\v^[A-Z0-9\-_()]{2,}(\s[A-Z0-9\-_()]+)*')<CR>]], { buffer = true })
vim.keymap.set("n", "[[", [[<Cmd>call search('\v^[A-Z0-9\-_()]{2,}(\s[A-Z0-9\-_()]+)*', 'b')<CR>]], { buffer = true })
