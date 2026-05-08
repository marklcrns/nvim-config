local cur = vim.wo.winhighlight
local add = "Folded:GitFolded,diffAdded:DiffInlineAdd,diffRemoved:DiffInlineDelete"
vim.wo.winhighlight = cur == "" and add or (cur .. "," .. add)
