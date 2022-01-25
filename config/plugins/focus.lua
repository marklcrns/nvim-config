require("focus").setup{
  enable = true,
  autoresize = true,
  hybridnumber = true,
  absolutenumber_unfocussed = true,
  colorcolumn = {enable = true, width = vim.api.nvim_get_option('textwidth')},
  bufnew =  true,
  excluded_filetypes = {"toggleterm"},
  -- Covered in core/filetype.vim
  cursorline = false,
  cursorcolumn = false,
}

