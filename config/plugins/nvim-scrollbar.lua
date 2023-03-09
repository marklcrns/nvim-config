require("scrollbar").setup({
  excluded_buftypes = {
    "terminal",
    "nowrite",
  },
  excluded_filetypes = {
    "prompt",
    "TelescopePrompt",
    "noice",
    "NvimTree",
    "minimap",
    "toggleterm",
    "lspsagaoutline",
    "NvimTree",
  },
  require("scrollbar.handlers.search").setup(),
  -- require("scrollbar.handlers.gitsigns").setup(),
})

vim.cmd([[
  augroup scrollbar_search_hide
      autocmd!
      autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
  augroup END
]])
