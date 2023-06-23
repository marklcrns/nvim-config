return function()
  ---@diagnostic disable-next-line: different-requires
  vim.notify = require("notify")
  vim.notify.setup({
    background_colour = "NotifyBackground",
    max_width = 80,
    max_height = 15,
    top_down = false,
    render = "compact",
  })
  vim.opt.cmdheight = 1
end
