vim.opt_local.list = false
vim.opt_local.colorcolumn = ""

vim.keymap.set("n", "Q", function()
  return vim.fn.bufnr("#") ~= -1 and "<C-^>" or "<Cmd>bp<CR>"
end, { buffer = true, expr = true })
