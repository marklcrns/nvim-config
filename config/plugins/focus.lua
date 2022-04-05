require("focus").setup{
  enable = true,
  autoresize = true,
  hybridnumber = true,
  signcolumn = false,
  treewidth = 30,
  -- width = vim.api.nvim_get_option('textwidth') + 10,
  -- absolutenumber_unfocussed = true,
  colorcolumn = { enable = true, width = vim.api.nvim_get_option('textwidth') },
  bufnew =  true,
  excluded_filetypes = { "toggleterm", "dashboard", "qf", "help" },
  compatible_filetrees = { "nvimtree", "nerdtree", "chadtree", "fern" },
  -- Covered in core/filetype.vim
  cursorline = false,
  cursorcolumn = false,
}

