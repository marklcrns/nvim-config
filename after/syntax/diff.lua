local hl = Config.common.hl
hl.hi("GitFolded", { fg = hl.get_fg("diffFile"), bg = hl.get_bg("Folded"), default = true })

local cur = vim.wo.winhighlight
local add = "diffAdded:DiffInlineAdd,diffRemoved:DiffInlineDelete"
vim.wo.winhighlight = cur == "" and add or (cur .. "," .. add)
