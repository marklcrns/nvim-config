return function()
  ---@diagnostic disable-next-line: different-requires
  local notify = require("notify")
  notify.setup({
    max_width = 80,
    max_height = 15,
    top_down = false,
    render = "wrapped-compact",
    stages = "static",
  })
  vim.notify = notify
  vim.opt.cmdheight = 1
end
