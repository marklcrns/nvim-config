-- Defer function call by 100 ms to let Copilot process catch up
vim.defer_fn(function()
  require("copilot").setup({
    suggestion = { enabled = false },
    panel = { enabled = false },
    filetypes = {
      yaml = false,
      -- markdown = false,
      help = false,
      gitcommit = false,
      gitrebase = false,
      hgcommit = false,
      svn = false,
      cvs = false,
      ["."] = false,
      ["*"] = true, -- for all other filetypes
    },
  })
end, 100)
