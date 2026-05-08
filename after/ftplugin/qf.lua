vim.opt_local.list = false
vim.opt_local.signcolumn = "yes:2"
vim.opt_local.number = false
vim.opt_local.relativenumber = false

local function jump_stack(reverse, use_loclist)
  local cmd
  if use_loclist then
    cmd = reverse and "lolder" or "lnewer"
  else
    cmd = reverse and "colder" or "cnewer"
  end
  pcall(vim.cmd, cmd)  -- swallow E380/E381 (no more/less items in list)
end

-- Navigate quickfix history
local is_loclist = #vim.fn.getloclist(0) > 0
vim.keymap.set("n", "J", function() jump_stack(false, is_loclist) end, { buffer = true })
vim.keymap.set("n", "K", function() jump_stack(true, is_loclist) end, { buffer = true })
