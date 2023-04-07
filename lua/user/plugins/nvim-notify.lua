return function()
  ---@diagnostic disable-next-line: different-requires
  vim.notify = require("notify")
  vim.notify.setup({
    max_width = 80,
    max_height = 15,
    top_down = false,
  })
end
