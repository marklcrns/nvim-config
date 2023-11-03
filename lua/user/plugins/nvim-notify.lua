return function()
  ---@diagnostic disable-next-line: different-requires
  vim.notify = require("notify")
  vim.notify.setup({
    background_colour = "NotifyBackground",
    max_width = 80,
    max_height = 15,
    top_down = false,
    render = "wrapped-compact",
    stages = "static",
  })
  vim.opt.cmdheight = 1
end
