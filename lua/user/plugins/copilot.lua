return function()
  require("copilot").setup({
    -- WARNING: copilot-cmp won't work if suggestion is enabled
    -- As it is now, auto trigger is not working with copilot-cmp. So use this instead
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = "<M-l>",
        accept_word = false,
        accept_line = false,
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
    panel = { enabled = false },
    filetypes = {
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
end
