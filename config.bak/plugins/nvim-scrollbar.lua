local colors = require("tokyonight.colors").setup()

require("scrollbar").setup({
  excluded_buftypes = {
    "terminal",
    "nowrite",
    "nofile",
    "prompt",
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
    "neo-tree",
  },
  show_in_active_only = true,
  hide_if_all_visible = true,
  throttle_ms = 50,
  handle = {
    color = colors.bg_highlight,
  },
  marks = {
    Search = { color = colors.orange },
    Error = { color = colors.error },
    Warn = { color = colors.warning },
    Info = { color = colors.info },
    Hint = { color = colors.hint },
    Misc = { color = colors.purple },
  },
})

vim.cmd([[
  augroup scrollbar_search_hide
      autocmd!
      autocmd CmdlineLeave : lua require('scrollbar.handlers.search').handler.hide()
  augroup END
]])
