require("focus").setup{
  enable = true,
  autoresize = true,
  hybridnumber = true,
  signcolumn = false,
  width = vim.api.nvim_get_option('textwidth') + 10,
  -- absolutenumber_unfocussed = true,
  colorcolumn = {enable = true, width = vim.api.nvim_get_option('textwidth')},
  bufnew =  true,
  excluded_filetypes = {"toggleterm", "dashboard"},
  -- Covered in core/filetype.vim
  cursorline = false,
  cursorcolumn = false,
}

