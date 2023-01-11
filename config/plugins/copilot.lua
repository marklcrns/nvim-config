-- Defer function call by 100 ms to let Copilot process catch up
vim.defer_fn(function()
  require("copilot").setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
  })
end, 100)
