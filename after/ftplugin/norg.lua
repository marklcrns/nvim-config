vim.opt_local.breakindentopt = "list:-1"
vim.opt_local.formatlistpat = [[^\s*[-~\*]\+\s\+]]

if vim.bo.readonly or not vim.bo.modifiable then
  vim.opt_local.concealcursor = "nc"
  vim.opt_local.conceallevel = 3
else
  vim.opt_local.shiftwidth = 2
  vim.opt_local.textwidth = 80
end

-- Try using conceal by default
vim.opt_local.concealcursor = "nc"
vim.opt_local.conceallevel = 3

vim.opt_local.listchars = "trail:" .. vim.opt.listchars:get().trail
