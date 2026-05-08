vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = "nvic"

vim.cmd([[
  syn match logDate /\v(Mon|Tue|Wed|Thu|Fri|Sat|Sun)\ \d{1,2}\ (Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\ \d{2,4}/
]])

if vim.fn.bufname():match("diffview%.log$") then
  vim.cmd([[
    syn match logPath /\v\S*\/\S*\/diffview.nvim\/lua\/diffview\// conceal
    syn match logPath /\v\.\.\.\S*\/lua\/diffview\// conceal
  ]])
end
