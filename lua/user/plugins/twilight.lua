return function()
  require("twilight").setup({
    dimming = {
      alpha = 0.25, -- amount of dimming
      color = { "Normal", "#ffffff" }, -- color of the dimmed text
      term_bg = "#000000", -- background color for terminal
      inactive = true, -- whether to dim inactive windows
    },
    context = 10, -- number of lines to show in context
    treesitter = true, -- enable treesitter for context detection
    expand = { "function", "method", "class" }, -- expand context for these nodes
    exclude = {}, -- list of filetypes to exclude from twilight
  })
end
